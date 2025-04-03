//
//  MapViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 28.03.2025.
//

import _MapKit_SwiftUI
import Foundation

@MainActor
final class MapViewModel: ObservableObject {
    
    private let networkManager: NetworkManagerProtocol
    
    @Published var events: [Event] = []
    
    @Published var selectedMapItem: Int? {
        didSet {
            setSelectedEvent()
            showDetails = selectedEvent != nil
        }
    }
    @Published var selectedEvent: Event?
    
    @Published var route: MKRoute?
    @Published var getRoute: Bool = false
    
    @Published var showDetails: Bool = false
    @Published var showingAlert = false
    @Published var showingRouteAlert = false
    
    @Published var routeError: String? {
        didSet {
            if routeError != nil {
                showingRouteAlert = true
            } else {
                showingAlert = false
            }
        }
    }
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        fetchEvents()
    }
    
    
    func fetchEvents() {
        networkManager.getTeamEvents(teamId: 1, completion: { [weak self] events in
            onMainThread {
                self?.events = events
            }
        })
    }
    
    func setSelectedEvent() {
        if let selectedMapItem = selectedMapItem {
            self.selectedEvent = events.first(where: {$0.id.hashValue == selectedMapItem.hashValue})
        } else {
            self.selectedEvent = nil
        }
    }
    
    func fetchRoute(userLocation: CLLocationCoordinate2D?) async  {
        guard let userLocation else { return }
        guard let selectedEvent else { return }
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let mapSelection = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedEvent.latitude), longitude: selectedEvent.longitude)))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.transportType = .walking
        request.destination = mapSelection
        
        do {
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            let firstRoute = response.routes.first
            self.route = firstRoute
            
        } catch {
            self.routeError = error.localizedDescription
            self.showingRouteAlert = true
            print(error.localizedDescription)
        }
        
        getRoute = false
    }
    
}




