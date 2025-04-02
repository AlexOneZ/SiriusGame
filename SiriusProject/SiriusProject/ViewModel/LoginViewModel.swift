//
//  LoginViewModel.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    @Published var teamName = ""
    @AppStorage("teamID") var teamID: Int = -1
    
    func newTeamRegister() {
        networkManager.enterTeam(name: teamName) { [weak self] id in
            onMainThread( {
                self?.teamID = id
            })
        }
    }
}
