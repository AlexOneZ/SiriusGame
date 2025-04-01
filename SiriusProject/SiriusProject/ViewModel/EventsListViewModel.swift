//
//  EventsListViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class EventsListViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let logging: Logging
    @Published var showRateView: Bool = false
    @Published var events: [Event] = []

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        fetchEvents()
    }

    func fetchEvents() {
        networkManager.getTeamEvents(teamId: 1, logging: logging, completion: { [weak self] events in
            onMainThread {
                self?.events = events
            }
        })
    }
}
