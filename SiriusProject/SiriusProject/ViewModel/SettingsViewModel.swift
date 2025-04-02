//
//  SettingsViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let logging: Logging
    @Published var teamName: String = ""

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        fetchTeamName()
    }

    func fetchTeamName() {
        networkManager.getTeam(teamId: 1, completion: { [weak self] team in
            onMainThread {
                if let team = team {
                    self?.teamName = team.name
                }
            }
        })
    }

    func changeName(newName: String) {
        networkManager.updateTeamName(teamId: 1, name: newName, completion: { [weak self] hasCompleted in
            onMainThread {
                if hasCompleted {
                    self?.teamName = newName
                }
            }
        })
    }

    func logOutAction() {}

    func getSendInfoURL(event: Event) -> URL? {
        let logMessage = "String to url: siriusgameurl://*\(event.id)*\(event.title)*\(String(describing: event.description))*\(event.state)*\(event.score)"
        logging(logMessage)

        return URL(string: "siriusgameurl://*\(event.id)*\(event.title)*\(String(describing: event.description))*\(event.state)*\(event.score)")
    }
}
