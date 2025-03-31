//
//  EventsListViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class EventsListViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var showRateView: Bool = false
    @Published var events: [Event] = []

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        fetchEvents()
    }

    func fetchEvents() {
        networkManager.getTeamEvents(teamId: 1) { [weak self] events in
            DispatchQueue.main.async {
                self?.events = events
            }
        }
    }
}
