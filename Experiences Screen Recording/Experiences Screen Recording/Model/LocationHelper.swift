//
//  LocationHelper.swift
//  Experiences Screen Recording
//
//  Created by Stephanie Bowles on 10/1/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    

    
    static let shared = LocationHelper()

    override init() {
        super.init()
        locationManager.delegate = self

        requestLocationAuthorization()
    }

    func requestLocationAuthorization() {

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }

    }

    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {

        requestLocationAuthorization()

        group = DispatchGroup()

        group?.enter()

        locationManager.requestLocation()


        group?.notify(queue: .main) {
            let coordinate = self.locationManager.location?.coordinate

            self.group = nil
            completion(coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        group?.leave()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }

    var group: DispatchGroup?

    private let locationManager = CLLocationManager()

    //POssible:?
//    let locationManager = CLLocationManager()
//
//    func requestLocationAuthorization() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func getCurrentLocation() -> CLLocation? {
//        return locationManager.location
//    }
}
