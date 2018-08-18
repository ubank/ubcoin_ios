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
    
    private var mapView: HUBBaseMapView!
    
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
        
        self.navigationContainer.rightTitle = "ui_button_save".localizedString()
        
        self.setupViews()
    
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupViews() {
        self.mapView = HUBBaseMapView()
        self.mapView.mapView.delegate = self
        self.mapView.mapView.settings.myLocationButton = true
        self.view.addSubview(self.mapView)
        self.view.addConstraints(toFillSubview: self.mapView)
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        if let location = self.locationString, let loc = self.currentLocation {
            self.completion?(location, loc)
        }
    }
}


extension UBCMapSelectController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clearMap()
        
        let marker = self.mapView.marker(withCoordinates: coordinate)
        marker?.icon = UIImage(named: "pin")
        
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
                marker?.snippet = self?.locationString
            }
        })
    }
}


extension UBCMapSelectController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil, let userLocation = locations.last  {
            self.mapView.camera(toCoord: userLocation.coordinate, withZoomLevel: 15)
            self.currentLocation = userLocation
        }
    }
}
