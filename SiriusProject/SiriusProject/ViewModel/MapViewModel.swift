//
//  MapViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 28.03.2025.
//

import _MapKit_SwiftUI
import Foundation

class MapViewModel: ObservableObject {
    var region: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.414215, longitude: 39.95040), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
}
