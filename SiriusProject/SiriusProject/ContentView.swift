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
            MapView()
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("map")
                }
            LeaderboardView(liderboardViewModel: appViewModel.leaderboardViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending")
                    Text("leaderboard")
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
    ContentView(appViewModel: AppViewModel(eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager()),
                                           settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager()),
                                           loginViewModel: LoginViewModel(networkManager: FakeNetworkManager()),
                                           pointsViewModel: PointsViewModel(networkManager: FakeNetworkManager()),
                                           leaderboardViewModel: LeaderboardViewModel(networkManager: FakeNetworkManager())))
        .environment(\.locale, .init(identifier: "ru"))
}
