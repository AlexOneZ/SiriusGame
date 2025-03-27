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


    func getPlaceColor(for place: Int) -> Color {
        switch place {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return Color(.systemGray6)
        }
    }
}
