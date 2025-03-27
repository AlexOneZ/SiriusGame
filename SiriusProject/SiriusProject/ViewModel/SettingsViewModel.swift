//
//  SettingsViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    var teamName: String {
        networkManager.getTeamName()
    }

    func logOutAction() {}
}
