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
    @AppStorage("teamID") var teamID: Int = 0

    @Published var events: [Event] = []

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        fetchEvents()
    }

    func fetchEvents() {
        print("try fetch events")
        if teamID > 0 {
            print("call network")
            networkManager.getTeamEvents(teamId: teamID, completion: { [weak self] events in
                onMainThread {
                    self?.events = events
                }
            })
        }
    }
}
