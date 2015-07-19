//
//  ViewController.swift
//  Where Am I
//
//  Created by Yohannes Wijaya on 7/19/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    let mapCoordinateZoomLevel: CLLocationDegrees = 0.007
    var locationManager: CLLocationManager!
    
    // MARK: - IBOutlet properties
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UIViewController methods override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.activityType = CLActivityType.Other
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        print(locations[0])
        let userLocation: CLLocation = locations[0] as! CLLocation
        let userLocationLatitude = userLocation.coordinate.latitude
        let userLocationLongitude = userLocation.coordinate.longitude
        let latitudeDeltaZoomLevel = self.mapCoordinateZoomLevel
        let longitudeDeltaZoomLevel = self.mapCoordinateZoomLevel
        let areaSpannedByMapRegion = MKCoordinateSpanMake(latitudeDeltaZoomLevel, longitudeDeltaZoomLevel)
        let geographicalCoordinateStruct = CLLocationCoordinate2DMake(userLocationLatitude, userLocationLongitude)
        let mapRegionToDisplay = MKCoordinateRegionMake(geographicalCoordinateStruct, areaSpannedByMapRegion)
        self.mapView.setRegion(mapRegionToDisplay, animated: true)
        self.latitudeLabel.text = "\(userLocationLatitude)"
        self.longitudeLabel.text = "\(userLocationLongitude)"
        self.altitudeLabel.text = "\(userLocation.altitude) meters"
        self.courseLabel.text = "\(userLocation.course) degrees"
        self.speedLabel.text = "\(userLocation.speed) meters / second"
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let poi = CLPlacemark(placemark: placemarks![0] as CLPlacemark) {
                var subThoroughfare: String = ""
                if poi.subThoroughfare != nil { subThoroughfare = poi.subThoroughfare }
                self.addressLabel.text = "\(subThoroughfare) \(poi.thoroughfare) \(poi.subLocality) \n \(poi.subAdministrativeArea), \(poi.administrativeArea) \(poi.postalCode). \(poi.country)."
            }
        })
    }
}

