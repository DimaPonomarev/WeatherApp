//
//  LocationManager.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 07.04.2023.
//


import Foundation
import CoreLocation

// MARK: LocationManager
class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    let locale = Locale(identifier: "en_GB")
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: extension LocationManager

extension LocationManager {
    
    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
    
            guard error == nil else {
                print("\(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("Placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
}
