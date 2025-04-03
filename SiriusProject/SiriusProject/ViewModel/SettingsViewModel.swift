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
    @AppStorage("teamID") var teamID: Int = 0

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        fetchTeamName()
    }

    func fetchTeamName() {
        if teamID > 0 {
            logging("try to get for id \(teamID)")
            networkManager.getTeam(teamId: teamID, completion: { [weak self] team in
                onMainThread {
                    if let team = team {
                        self?.teamName = team.name
                    }
                }
            })
        } else {
            logging("ID not defined")
        }
    }

    func changeName(newName: String) {
        if teamID > 0 {
            logging("try get events for team id \(teamID)")
            networkManager.updateTeamName(teamId: teamID, name: newName, completion: { [weak self] hasCompleted in
                onMainThread {
                    if hasCompleted {
                        self?.logging("Succes change name")
                        self?.teamName = newName
                    }
                }
            })
        }
    }

    func logOutAction() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set(false, forKey: "isJudge")
        UserDefaults.standard.set(0, forKey: "teamID")
    }
}
