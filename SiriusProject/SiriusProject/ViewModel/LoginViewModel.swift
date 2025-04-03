//
//  LoginViewModel.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let logging: Logging

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    @Published var teamName = ""
    @AppStorage("teamID") var teamID: Int = 0

    func newTeamRegister() {
        logging("Try register new team \(teamName)")
        networkManager.enterTeam(name: teamName) { [weak self] id in
            onMainThread {
                self?.logging("try setup id \(id)")
                self?.teamID = id
            }
        }
    }
}
