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
    
    private var locationManager = CLLocationManager()
    private let locale = Locale(identifier: "en_GB")
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
}

// MARK: extension LocationManager

extension LocationManager {
    
//    MARK: - first detemination of currentWeather
    
    public func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
//    MARK: - make request with current location to get data when MainViewController just opened
    
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
