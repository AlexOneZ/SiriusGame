//
//  MapView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 27.03.2025.
//
import MapKit
import SwiftUI

struct MapView: View {
//    @State private var region: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.414215, longitude: 39.95040), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    @ObservedObject var viewModel: MapViewModel

    init(mapViewModel: MapViewModel) {
        viewModel = mapViewModel
    }

    let point = CLLocationCoordinate2D(latitude: 43.40222213237247, longitude: 39.95576828887273)

    var body: some View {
        Map(position: $viewModel.region) {
            Marker("Football", coordinate: point)
        }
    }
}
