//
//  ContentView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 25.03.2025.
//

import SwiftUI

struct ContentView: View {
    var appViewModel: AppViewModel

    @AppStorage("isTeamLoggedIn") var isTeamLoggedIn: Bool = false
    @ObservedObject var notificationsManager: NotificationsManager
    private let logging: Logging

    init(appViewModel: AppViewModel, notificationsManager: NotificationsManager) {
        self.appViewModel = appViewModel
        logging = appViewModel.logging
        self.notificationsManager = notificationsManager
    }

    var body: some View {
        TabView {
            EventsListView(
                appViewModel: appViewModel, eventsListViewModel: appViewModel.eventsListViewModel,
                isNotificationViewShowing: $notificationsManager.isNotificationViewShowing
            )
            .tabItem {
                Image(systemName: "rectangle.on.rectangle")
                Text("events")
            }
            MapView(
                viewModel: appViewModel.mapViewModel)
                .tabItem {
                    Image(systemName: "mappin.circle")
                    Text("map")
                }
            LeaderboardView(liderboardViewModel: appViewModel.leaderboardViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending")
                    Text("leaderboard")
                }

            SettingsView(settingsViewModel: appViewModel.settingsViewModel, logging: logging)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
        .sheet(isPresented: $notificationsManager.isNotificationViewShowing) {
            NotificationsView(
                notificationsViewModel: appViewModel.notificationsViewModel,
                isNotificationViewShowing:
                $notificationsManager.isNotificationViewShowing,
                log: logging
            )
        }
    }
}

#Preview {
    ContentView(
        appViewModel: AppViewModel(
            logging: printLogging,
            eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            loginViewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: { _ in }),
            pointsViewModel: PointsViewModel(networkManager: FakeNetworkManager(logging: printLogging)),
            leaderboardViewModel: LeaderboardViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            mapViewModel: MapViewModel(networkManager: FakeNetworkManager(logging: printLogging)),
            notificationsViewModel: NotificationsViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            getRateReviewModel: GetRateReviewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            createEventViewModel: CreateEventViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: { _ in })
        ),
        notificationsManager: NotificationsManager()
    )
    .environment(\.locale, .init(identifier: "ru"))
}
