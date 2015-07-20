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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var secondAddressLabel: UILabel!
    
    // MARK: - UIViewController methods override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
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
        let userLocation = locations[0] as! CLLocation
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
        self.altitudeLabel.text = "\(userLocation.altitude) m"
        self.courseLabel.text = "\(self.checkUserLocationPropertyValueForZero(userLocation.course)) °"
        self.speedLabel.text = "\(Int(self.checkUserLocationPropertyValueForZero(userLocation.speed * 3.6))) kph"
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let poi = CLPlacemark(placemark: placemarks![0] as CLPlacemark) {
                if let subThoroughfare = poi.subThoroughfare {
                    self.firstAddressLabel.text = "\(subThoroughfare) \(poi.thoroughfare)."
                }
                else {
                    self.firstAddressLabel.text = "\(poi.thoroughfare)."
                }
                self.secondAddressLabel.text = "\(poi.subAdministrativeArea), \(poi.administrativeArea) \(poi.postalCode). \(poi.country)."
            }
        })
    }
    
    // MARK: - Local methods
    
    func checkUserLocationPropertyValueForZero(arg: Double) -> Double {
        if arg < 0 { return 0 }
        else { return arg }
    }
}

