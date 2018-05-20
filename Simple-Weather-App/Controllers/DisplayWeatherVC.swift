//
//  DisplayWeatherVC.swift
//  Simple-Weather-App
//
//  Created by Chad Wiedemann on 5/19/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DisplayWeatherVC: UIViewController {

    let locationManger = CLLocationManager()
    var annotation: MKAnnotation?
    @IBOutlet weak var currentLocationMapView: MKMapView!
    @IBOutlet weak var weatherTableView: UITableView!
    let dao = DataAccessObject.sharedInstance
    let networker: NetworkController!
    
    init(networker: NetworkController) {
        self.networker = networker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.networker = NetworkController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.placeAnnotation), name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.loadTableView), name: NSNotification.Name(rawValue: "finishedAPICallsForSavedLocations"), object: nil)
        currentLocationMapView.showsUserLocation = true
        self.locationManger.delegate = self
        self.locationManger.requestWhenInUseAuthorization()
        dao.loadSavedLocations()
    }
    
    @objc private func loadTableView() {
        weatherTableView.reloadData()
    }
    
    @objc private func placeAnnotation() {
        dropPin()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dao.saveCurrentLocation()
        weatherTableView.reloadData()
    }
    
}

extension DisplayWeatherVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dao.savedLocations.isEmpty || dao.savedLocations.count <= indexPath.row {
            return UITableViewCell()
        }
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "identifier")
        }
        let location = dao.savedLocations[indexPath.row]
        cell.textLabel?.text = "\(location.name)-\(location.currentWeatherConditions!.weatherString)-humidity \(location.currentWeatherConditions!.humidity)"
        return cell
    }
}

extension DisplayWeatherVC: MKMapViewDelegate, CLLocationManagerDelegate{
    func dropPin() {
        let currentlocation = dao.currentLocation!
        annotation = MyLocationAnnotation(coordinate: currentlocation.coordinates, title: currentlocation.name, conditions: currentlocation.currentWeatherConditions!.weatherString)
        guard let annotation = annotation else{
            return
        }
        currentLocationMapView.addAnnotation(annotation)
        currentLocationMapView.selectAnnotation(annotation, animated: true)
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MyLocationAnnotation else { return nil }
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UILabel()
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let regionRadius = 400000
        let myLocation = userLocation.coordinate
        let coordinateRegion = MKCoordinateRegionMakeWithDistance( myLocation, CLLocationDistance(regionRadius), CLLocationDistance(regionRadius) )
        self.currentLocationMapView.setRegion( coordinateRegion, animated: true)
        networker.getWeatherForCurrentLocation(myLocation)
        locationManger.stopUpdatingLocation()
        currentLocationMapView.showsUserLocation = false
    }
}
