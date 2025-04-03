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
    @StateObject var locationManager = LocationManager()

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Map(position: $locationManager.region, interactionModes: .all, selection: $viewModel.selectedMapItem) {
            ForEach(viewModel.events, id: \.id) { event in
                Marker(
                    event.title,
                    systemImage: SportIconProvider.getSportIconCircle(for: event.title),
                    coordinate: CLLocationCoordinate2D(
                        latitude: event.latitude,
                        longitude: event.longitude
                    )
                )
                .tag(event.id)
                .tint(event.state.getColor())
            }

            UserAnnotation()

            if let route = viewModel.route {
                MapPolyline(route)
                    .stroke(Color(.siriusPurple2), lineWidth: 5)
            }
        }

        .overlay(alignment: .bottomTrailing) {
            if viewModel.route != nil {
                Button {
                    viewModel.route = nil
                    viewModel.selectedMapItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray)
                        .padding()
                }
            }
        }

        .alert(
            locationManager.errorMessage ?? "",
            isPresented: $viewModel.showingAlert
        ) {
            Button("OK", role: .cancel) {}
        }
        .alert(
            viewModel.routeError ?? "",
            isPresented: $viewModel.showingRouteAlert
        ) {
            Button("OK", role: .cancel) {
                viewModel.routeError = nil
            }
        }

        .sheet(isPresented: $viewModel.showDetails, content: {
            if let event = viewModel.selectedEvent {
                LoactionDetails(
                    event: event,
                    getRoute: $viewModel.getRoute,
                    selectemMapItem: $viewModel.selectedMapItem,
                    show: $viewModel.showDetails
                )
                .presentationDetents([.height(120)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(120)))
            }
        })

        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
            MapCompass()
        }

        .onAppear {
            locationManager.startUpdatingLocation()
            viewModel.fetchEvents()
        }

        .onChange(of: viewModel.getRoute) { _, newValue in
            if newValue {
                Task {
                    await viewModel.fetchRoute(userLocation: locationManager.userLocation)
                }
            }
        }
    }
}

#Preview {
    MapView(viewModel: MapViewModel(networkManager: FakeNetworkManager(logging: printLogging)))
}
