//
//  GetRateReviewModel.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 02.04.2025.
//

import SwiftUI

class GetRateReviewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var rateSend: Bool = false

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func setTeamEventScore(teamID: Int, score: Int) {
        networkManager.setTeamEventScore(teamId: teamID, score: score) { [weak self] isSet in
            onMainThread {
                self?.rateSend = isSet
            }
        }
    }
}
