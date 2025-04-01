//
//  LeaderboardViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 27.03.2025.
//

import Foundation
import SwiftUI

final class LeaderboardViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    var sortedTeams: [Team]

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        sortedTeams = networkManager.getTeams().sorted(by: { $0.score > $1.score })
    }
}
