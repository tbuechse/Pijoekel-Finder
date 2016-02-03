//
//  SecondViewController.swift
//  DevBootcamps
//
//  Created by Tim on 02.02.16.
//  Copyright © 2016 Tim. All rights reserved.
//

import UIKit
import MapKit

// Check Ctr CLick für die Methods des MapViewDelegates

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    
    //implicitly unwrapped optional, sure to stick to the LocationVC
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius : CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    //Lets pretend we downloaded these from the server
    
    let adresses = [
    "Marienburger Str. 7, 10405 Berlin",
    "Prenzlauer Allee 42, 10405 Berlin"
    
    
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // siehe funnction unten getPlacemarkFromAdressa
        for add in adresses {
            getPlacemarkFromAdress(add)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
    locationAuthStatus()
        
    
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }

    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
        map.showsUserLocation = true
        } else {
        locationManager.requestWhenInUseAuthorization()
        
        }
    }
    
    func centerMapOnLocation (location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let loc = userLocation.location {
        centerMapOnLocation(loc)
            
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(BootcampAnnotation) {
            
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blackColor()
            annoView.animatesDrop = true
            return annoView
            
        } else if annotation.isKindOfClass(MKUserLocation) {
            // Nicht unbedingt nötig, hier ausführlicher
            return nil
        }
        //Nötig!
        return nil
        
    }
    
    func createAnnotationForLocation(location: CLLocation){
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate)
        map.addAnnotation(bootcamp)
    }
    
    
    func getPlacemarkFromAdress(adress: String) {
        CLGeocoder().geocodeAddressString(adress) { (placemarks: [CLPlacemark]?, error:NSError?) -> Void in
            // Swift Way: Prüfung ob Wert; vorhanden, make sure to have objects
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                // We have a valid location with coordinates
                    //"if lets" -> valid objects
                    // Use self inside the closure to call the function
                    // Pass in loc
                    self.createAnnotationForLocation(loc)
                }
            }
        }
    
    }

}

