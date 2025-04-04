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
    let liveActivtityManager: LiveActivityManager
    var score: Int = 0
    @AppStorage("teamID") var teamID: Int = 0

    @Published var events: [Event] = []

    init(networkManager: NetworkManagerProtocol, liveActivtityManager: LiveActivityManager, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        self.liveActivtityManager = liveActivtityManager
        fetchEvents()
        startLiveActivity()
    }

    private func startLiveActivity() {
        let currentEvent = events.first(where: { $0.state == EventState.now })
        let nextEvent = events.first(where: { $0.state == EventState.next })
        fetchTeamScore()
        liveActivtityManager.startActivity(currentEvent: currentEvent, nextEvent: nextEvent, score: score)
    }

    func updateLiveActivity() {
        let currentEvent = events.first(where: { $0.state == EventState.now })
        let nextEvent = events.first(where: { $0.state == EventState.next })
        fetchTeamScore()
        liveActivtityManager.updateActivity(currentEvent: currentEvent, nextEvent: nextEvent, score: score)
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

    func fetchTeamScore() {
        networkManager.getTeam(teamId: teamID, completion: { [weak self] team in
            self?.score = team?.score ?? 0
        })
        print("score: \(score)")
    }
}
