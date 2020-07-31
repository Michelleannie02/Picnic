//
//  LocationManager.swift
//  Picnic
//
//  Created by Kyle Burns on 7/27/20.
//  Copyright © 2020 Kyle Burns. All rights reserved.
//

import MapKit

class LocationManager: CLLocationManager {
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        requestAlwaysAuthorization()
        startUpdatingLocation()
        desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension CLLocationCoordinate2D {
    func getPlacemark(completion: @escaping (CLPlacemark) -> ()) {
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(loc) { placemark, error in
            if let err = error {
                print("Error: CLLocationCoordinate2D: getPlacemark: \(err.localizedDescription)")
                return
            }
            if let location = placemark?.first {
                completion(location)
            }
        }
    }
}

extension CLLocation {
    func getPlacemark(completion: @escaping(CLPlacemark) ->()) {
        CLGeocoder().reverseGeocodeLocation(self) { placemark, error in
            if let err = error {
                print("Error: CLLocationCoordinate2D: getPlacemark: \(err.localizedDescription)")
                return
            }
            if let location = placemark?.first {
                completion(location)
            }
        }
    }
}
