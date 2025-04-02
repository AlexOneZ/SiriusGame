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
                eventsListViewModel: appViewModel.eventsListViewModel,
                isNotificationViewShowing: $notificationsManager.isNotificationViewShowing
            )
            .tabItem {
                Image(systemName: "rectangle.on.rectangle")
                Text("events")
            }
            MapView(
                mapViewModel: appViewModel.mapViewModel,
                isNotificationViewShowing: $notificationsManager.isNotificationViewShowing
            )
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
        .onOpenURL { url in
            let event = url.recieveDeeplinkURL(logging: logging)
            let logMessage = """
                \(event?.id ?? -1),
                \(event?.title ?? "no title"),
                \(event?.description ?? "no description"),
                \(event?.state ?? EventState.now),
                \(event?.score ?? -100)
            """
            logging(logMessage)
        }
        .sheet(isPresented: $notificationsManager.isNotificationViewShowing) {
            NotificationsView(
                isNotificationViewShowing: $notificationsManager.isNotificationViewShowing,
                viewModel: appViewModel.notificationsViewModel
            )
        }
    }
}

private extension URL {
    func recieveDeeplinkURL(logging: @escaping Logging) -> Event? {
        let infoFromURL = absoluteString
        let parsedInfo = infoFromURL.split(separator: "*")

        guard let id = Int(parsedInfo[1]) else {
            logging("ID not converted!")
            return nil
        }
        let title = String(parsedInfo[2])
        let description = String(parsedInfo[3])
        guard let eventState = EventState(rawValue: String(parsedInfo[4])) else {
            logging("StateEvent not converted")
            return nil
        }
        guard let score = Int(parsedInfo[5]) else {
            logging("Score not converted")
            return nil
        }

        return Event(
            id: id,
            title: title,
            description: description,
            state: eventState,
            score: score
        )
    }
}

#Preview {
    ContentView(
        appViewModel: AppViewModel(
            logging: printLogging,
            eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            loginViewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging)),
            pointsViewModel: PointsViewModel(networkManager: FakeNetworkManager(logging: printLogging)),
            leaderboardViewModel: LeaderboardViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging),
            mapViewModel: MapViewModel(),
            notificationsViewModel: NotificationsViewModel(networkManager: FakeNetworkManager(logging: printLogging))
        ),
        notificationsManager: NotificationsManager()
    )
    .environment(\.locale, .init(identifier: "ru"))
}
