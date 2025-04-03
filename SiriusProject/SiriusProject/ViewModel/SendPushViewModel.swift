//
//  SendPushViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import Foundation

class SendPushViewModel: ObservableObject {
    @Published var pushText: String = ""

    var canSubmit: Bool {
        return !pushText.isEmpty
    }

    let networkManager: NetworkManagerProtocol
    let logging: Logging

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    func sendPush() {}
}
