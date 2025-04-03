//
//  NotificationsViewModel.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 29.03.2025.
//

import SwiftUI

final class NotificationsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    let logging: Logging
    @Published var isLoading = false
    @Published var notifications: [Notification] = []
    @AppStorage("notificationsToken") var token = ""

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    func getHistoryNotifications() {
        isLoading = true
        networkManager.getHistoryNotifications(token: token, completion: { [weak self] notifications in
            onMainThread {
                self?.notifications = notifications
                self?.isLoading = false
            }
        })
    }
}
