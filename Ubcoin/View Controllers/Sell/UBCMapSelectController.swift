//
//  UBCMapSelectController.swift
//  Ubcoin
//
//  Created by Aidar on 08/07/2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UBCMapSelectController: UBViewController {
    
    var completion: ((String, CLLocation) -> Void)?
    
    private var mapView: MKMapView!
    
    private var locationString: String?
    private var geocode = CLGeocoder()
    private var currentLocation: CLLocation?
    
    private(set) lazy var locationManager: CLLocationManager = { [unowned self] in
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationManager
    }()
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationContainer.rightTitle = "Save"
        
        self.setupViews()
    
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupViews() {
        self.mapView = MKMapView()
        self.mapView.showsUserLocation = true
        self.view.addSubview(self.mapView)
        self.view.addConstraints(toFillSubview: self.mapView)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapOnMap(gesture:)))
        longGesture.minimumPressDuration = 1
        self.mapView.addGestureRecognizer(longGesture)
    }
    
    @objc private func tapOnMap(gesture: UIGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)

        let touchPoint = gesture.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.geocode.reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
            if error == nil, let selectedLocation = placemarks?.first {
                var title = ""
                if let country = selectedLocation.country {
                    title += country + ", "
                }
                if let locality = selectedLocation.locality {
                    title += locality + ", "
                }
                if let thoroughfare = selectedLocation.thoroughfare {
                    title += thoroughfare + ", "
                }
                if let subThoroughfare = selectedLocation.subThoroughfare {
                    title += subThoroughfare + ", "
                }
                
                self?.locationString = String(title.dropLast(2))
                annotation.title = self?.locationString
            }
        })
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        if let completion = self.completion, let location = self.locationString, let loc = self.currentLocation {
            completion(location, loc)
        }
    }
}


extension UBCMapSelectController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil, let userLocation = locations.last  {
            let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(viewRegion, animated: false)
        }
        
        self.currentLocation = locations.last
    }
}
