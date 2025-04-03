//
//  LocationManager.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 02.04.2025.
//

import _MapKit_SwiftUI
import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.40249662803451, longitude: 39.951579184906024), // Адлер
        span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
    ))
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var errorMessage: LocalizedStringKey?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestPermission()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.startUpdatingLocation()
            case .denied, .restricted:
                self.errorMessage = "dostupklocationzapreshen"
                self.stopUpdatingLocation()
            case .notDetermined:
                self.requestPermission()
            @unknown default:
                self.errorMessage = "neizvestnayalocationerror"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        onMainThread {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onMainThread {
            self.errorMessage = "locationerror"
        }
    }
}
