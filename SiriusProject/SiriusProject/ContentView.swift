//
//  ContentView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 25.03.2025.
//

import SwiftUI

struct ContentView: View {
    var appViewModel: AppViewModel

    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    var body: some View {
        TabView {
            EventsListView(eventsListViewModel: appViewModel.eventsListViewModel)
                .tabItem {
                    Image(systemName: "rectangle.on.rectangle")
                    Text("events")
                }
            SettingsView(settingsViewModel: appViewModel.settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
    }
}

#Preview {
    ContentView(appViewModel: AppViewModel(eventsListViewModel: EventsListViewModel(networkManager: NetworkManager()), settingsViewModel: SettingsViewModel(networkManager: NetworkManager())))
        .environment(\.locale, .init(identifier: "ru"))
}
