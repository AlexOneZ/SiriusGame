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
        networkManager.getTeam(teamId: 1) { [weak self] team in
            DispatchQueue.main.async {
                if let team = team {
                    self?.teamName = team.name
                } else {
                    print("Ошибка при получении команды")
                }
            }
        }
    }

    func changeName(newName: String) {
        networkManager.updateTeamName(teamId: 1, name: newName) { [weak self] hasCompleted in
            DispatchQueue.main.async {
                if hasCompleted {
                    self?.teamName = newName
                } else {
                    print("Ошибка при смене имени")
                }
            }
        }
    }

    func logOutAction() {}
}
