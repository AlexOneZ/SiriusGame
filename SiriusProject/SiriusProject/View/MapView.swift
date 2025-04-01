//
//  MapView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 27.03.2025.
//
import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    @Binding var isNotificationViewShowing: Bool

    init(
        mapViewModel: MapViewModel,
        isNotificationViewShowing: Binding<Bool>
    ) {
        viewModel = mapViewModel
        _isNotificationViewShowing = isNotificationViewShowing
    }

    let point = CLLocationCoordinate2D(latitude: 43.40222213237247, longitude: 39.95576828887273)

    var body: some View {
        Map(position: $viewModel.region) {
            Marker("Football", coordinate: point)
        }
        .overlay(alignment: .bottomTrailing) {
            NotificationsButton(
                action: { isNotificationViewShowing = true }
            )
            .padding(.trailing, 30)
            .padding(.bottom, 40)
        }
    }
}
