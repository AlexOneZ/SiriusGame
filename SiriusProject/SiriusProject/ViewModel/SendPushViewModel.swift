//
//  SendPushViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import Foundation

class SendPushViewModel: ObservableObject {
    @Published var pushTitle: String = ""
    @Published var pushText: String = ""

    var canSubmit: Bool {
        return !pushText.isEmpty && !pushTitle.isEmpty
    }

    let networkManager: NetworkManagerProtocol
    let logging: Logging

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    func sendPush() {
        networkManager.sendTextPushesToAll(text: pushText, title: pushTitle) { _ in }
        pushText = ""
        pushTitle = ""
    }
}
