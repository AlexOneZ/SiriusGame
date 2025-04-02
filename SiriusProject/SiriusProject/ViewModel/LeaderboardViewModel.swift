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
    let logging: Logging
    var sortedTeams: [Team] = []

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
        networkManager.getTeams(completion: { [weak self] teams in
            self?.sortedTeams = teams.sorted(by: { $0.score > $1.score })
        })
    }
}
