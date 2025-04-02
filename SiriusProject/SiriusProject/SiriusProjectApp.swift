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
    var notificationsManager: NotificationsManager

    var appViewModel: AppViewModel
    let logging: Logging
    let errorLogging: Logging
    let errorPublisher: ErrorPublisher

    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate

    @AppStorage("isJudge") var isJudge: Bool = false
    @AppStorage("isLogin") var isLogin: Bool = false

    init() {
        errorPublisher = ErrorPublisher()

        logging = { message in
            printLogging(message)
        }

        errorLogging = errorPublisherLogging(errorPublisher)

        networkManager = NetworkManager(service: APIService(urlSession: URLSession.shared), logging: errorLogging)
        notificationsManager = NotificationsManager()

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
        appDelegate.setup(notificationCenter: center, runner: onMainThread, notificationsManager: notificationsManager, networkManager: networkManager as! NetworkManager)
    }

    var body: some Scene {
        WindowGroup {
            ErrorHandlerView(errorPublisher: errorPublisher) {
                if isLogin {
                    if isJudge {
                        JudgeContentView(appViewModel: appViewModel)
                    } else {
                        ContentView(
                            appViewModel: appViewModel,
                            notificationsManager: notificationsManager
                        )
                    }
                } else {
                    LoginView(viewModel: appViewModel.loginViewModel)
                }
            }
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
