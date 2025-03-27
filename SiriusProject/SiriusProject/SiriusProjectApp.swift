//
//  SiriusProjectApp.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 25.03.2025.
//

import SwiftUI
import UserNotifications

@main
struct SiriusProjectApp: App {
    let networkManager: NetworkManagerProtocol
    var appViewModel: AppViewModel
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate

    init() {
        networkManager = FakeNetworkManager()
        appViewModel = AppViewModel(
            eventsListViewModel: EventsListViewModel(networkManager: networkManager),
            settingsViewModel: SettingsViewModel(networkManager: networkManager),
            loginViewModel: LoginViewModel(networkManager: networkManager),
            pointsViewModel: PointsViewModel(networkManager: networkManager),
            leaderboardViewModel: LeaderboardViewModel(networkManager: networkManager),
            notificationsViewModel: NotificationsViewModel(networkManager: networkManager)
        )

        let center = UNUserNotificationCenter.current()
        appDelegate.setup(notificationCenter: center, runner: onMainThread)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appViewModel: appViewModel)
        }
    }
}

struct AppViewModel {
    var eventsListViewModel: EventsListViewModel
    var settingsViewModel: SettingsViewModel
    var loginViewModel: LoginViewModel
    var pointsViewModel: PointsViewModel
    var leaderboardViewModel: LeaderboardViewModel
    var notificationsViewModel: NotificationsViewModel
}
