//
//  SiriusProjectApp.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 25.03.2025.
//

import SwiftUI

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
            notificationsViewModel: NotificationsViewModel(networkManager: networkManager)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appViewModel: appViewModel)
                .onAppear(perform: {
                    appDelegate.app = self
                })
        }
    }
}

struct AppViewModel {
    var eventsListViewModel: EventsListViewModel
    var settingsViewModel: SettingsViewModel
    var loginViewModel: LoginViewModel
    var pointsViewModel: PointsViewModel
    var notificationsViewModel: NotificationsViewModel
}
