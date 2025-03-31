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
    var sortedTeams: [Team] = []

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getTeams(completion: { [weak self] teams in
            self?.sortedTeams = teams.sorted(by: { $0.score > $1.score })
        })
    }
}
