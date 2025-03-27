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
        self.networkManager = FakeNetworkManager()
        appViewModel = AppViewModel(eventsListViewModel: EventsListViewModel(networkManager: self.networkManager),
                                    settingsViewModel: SettingsViewModel(networkManager: self.networkManager))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appViewModel: self.appViewModel)
        }
    }
}

struct AppViewModel {
    var eventsListViewModel: EventsListViewModel
    var settingsViewModel: SettingsViewModel
}
