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
    
    private var locationString: String?
    private var geocode = CLGeocoder()
    private var currentLocation: CLLocation?
    private var selectLocation: CLLocation?
    private var canSelectLocation: Bool = true
    
    private lazy var locationManager: CLLocationManager = { [unowned self] in
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        return locationManager
    }()
    
    private lazy var mapView: HUBBaseMapView = { [unowned self] in
        let mapView = HUBBaseMapView()
        
        mapView.mapView.delegate = self
        mapView.mapView.settings.myLocationButton = true
        
        return mapView
    }()
    
    private lazy var locationTitle: UILabel = { [unowned self] in
        let label = UILabel()
        
        label.backgroundColor = .white
        label.cornerRadius = UBCConstant.cornerRadius
        label.font = UBCFont.title
        label.textColor = UBColor.titleColor
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0
        
        return label
    }()
    
    convenience init(title: String, location: CLLocation? = nil) {
        self.init()
        
        self.title = title
        
        if let location = location {
            self.selectLocation = location
            self.canSelectLocation = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.canSelectLocation {
            self.navigationContainer.rightTitle = "ui_button_save".localizedString()
        }
        
        self.setupViews()
    
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        if let selectLocation = self.selectLocation {
            self.select(coordinate: selectLocation.coordinate)
            self.mapView.camera(toCoord: selectLocation.coordinate, withZoomLevel: 15)
        }
    }
    
    private func setupViews() {
        self.view.addSubview(self.mapView)
        self.view.addConstraints(toFillSubview: self.mapView)
    
        self.view.addSubview(self.locationTitle)
        self.view.setLeadingConstraintToSubview(self.locationTitle, withValue: 16)
        self.view.setTrailingConstraintToSubview(self.locationTitle, withValue: -16)
        self.view.setTopConstraintToSubview(self.locationTitle, withValue: 16)
    }
    
    override func rightBarButtonClick(_ sender: Any!) {
        if let location = self.locationString, let loc = self.selectLocation {
            self.completion?(location, loc)
        } else {
            UBAlert.show(withTitle: "ui_alert_title_attention", andMessage: "error_location_not_selected")
        }
    }
    
    private func select(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        self.mapView.clearMap()
        self.mapView.marker(withCoordinates: coordinate)
        
        self.selectLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        guard let location = self.selectLocation else { return }
        
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
                self?.locationTitle.isHidden = false
                self?.locationTitle.text = self?.locationString
            } else {
                self?.locationTitle.isHidden = true
            }
        })
    }
}


extension UBCMapSelectController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.canSelectLocation {
            self.select(coordinate: coordinate)
        }
    }
}


extension UBCMapSelectController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentLocation == nil, self.canSelectLocation, let userLocation = locations.last  {
            self.mapView.camera(toCoord: userLocation.coordinate, withZoomLevel: 15)
            self.currentLocation = userLocation
            self.select(coordinate: self.currentLocation?.coordinate)
        }
    }
}
