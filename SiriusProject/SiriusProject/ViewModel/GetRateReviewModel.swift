//
//  GetRateReviewModel.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 03.04.2025.
//

import SwiftUI

class GetRateReviewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var rateSend: Bool = false
    let logging: Logging

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    func setTeamEventScore(teamID: Int, score: Int) {
        networkManager.setTeamEventScore(teamId: teamID, score: score) { [weak self] isSet in
            print("setTeamEvent \(teamID) \(score)")
            onMainThread {
                self?.rateSend = isSet
            }
        }
    }
}
