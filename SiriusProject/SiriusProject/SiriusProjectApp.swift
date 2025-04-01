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
    let logging: Logging
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate

    init() {
        logging = { message in
            printLogging(message)
        }
        networkManager = NetworkManager(service: APIService(urlSession: URLSession.shared), logging: logging)

        appViewModel = AppViewModel(
            logging: logging,
            eventsListViewModel: EventsListViewModel(networkManager: networkManager, logging: logging),
            settingsViewModel: SettingsViewModel(networkManager: networkManager, logging: logging),
            loginViewModel: LoginViewModel(networkManager: networkManager),
            pointsViewModel: PointsViewModel(networkManager: networkManager),
            leaderboardViewModel: LeaderboardViewModel(networkManager: networkManager, logging: logging),
            mapViewModel: MapViewModel(),
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
    let logging: Logging
    var eventsListViewModel: EventsListViewModel
    var settingsViewModel: SettingsViewModel
    var loginViewModel: LoginViewModel
    var pointsViewModel: PointsViewModel
    var leaderboardViewModel: LeaderboardViewModel
    var mapViewModel: MapViewModel
    var notificationsViewModel: NotificationsViewModel
}
