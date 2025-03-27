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

    init() {
        networkManager = FakeNetworkManager()
        appViewModel = AppViewModel(
            eventsListViewModel: EventsListViewModel(networkManager: networkManager),
            settingsViewModel: SettingsViewModel(networkManager: networkManager)
        )
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
}
