//
//  SettingsViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var teamName: String = ""

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        fetchTeamName()
    }

    func fetchTeamName() {
        networkManager.getTeam(teamId: 1, logging: printLogging, completion: { [weak self] team in
            onMainThread {
                if let team = team {
                    self?.teamName = team.name
                }
            }
        })
    }

    func changeName(newName: String) {
        networkManager.updateTeamName(teamId: 1, name: newName, logging: printLogging, completion: { [weak self] hasCompleted in
            onMainThread {
                if hasCompleted {
                    self?.teamName = newName
                }
            }
        })
    }

    func logOutAction() {}
}
