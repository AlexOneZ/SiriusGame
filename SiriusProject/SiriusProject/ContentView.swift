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
    @State var isNotificationViewShowing: Bool = false
    private let log: (String) -> Void

    init(appViewModel: AppViewModel, log: @escaping (String) -> Void = { message in
        #if DEBUG
            print(message)
        #endif
    }) {
        self.appViewModel = appViewModel
        self.log = log
    }

    var body: some View {
        //        if !isTeamLoggedIn {
        //            LoginView(viewModel: appViewModel.loginViewModel)
        //        } else {
        TabView {
            EventsListView(
                eventsListViewModel: appViewModel.eventsListViewModel,
                isNotificationViewShowing: $isNotificationViewShowing
            )
            .tabItem {
                Image(systemName: "rectangle.on.rectangle")
                Text("events")
            }
            MapView(
                mapViewModel: appViewModel.mapViewModel,
                isNotificationViewShowing: $isNotificationViewShowing
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
            SettingsView(settingsViewModel: appViewModel.settingsViewModel, log: log)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
        .onOpenURL { url in
            let event = url.recieveDeeplinkURL(log: log)
            let logMessage = """
                \(event?.id ?? -1),
                \(event?.title ?? "no title"),
                \(event?.description ?? "no description"),
                \(event?.state ?? EventState.now),
                \(event?.score ?? -100)
            """
            log(logMessage)
        }
        .sheet(isPresented: $isNotificationViewShowing) {
            NotificationsView(
                isNotificationViewShowing: $isNotificationViewShowing,
                viewModel: appViewModel.notificationsViewModel
            )
        }
    }
}

private extension URL {
    func recieveDeeplinkURL(log: @escaping (String) -> Void = { _ in }) -> Event? {
        let infoFromURL = absoluteString
        let parsedInfo = infoFromURL.split(separator: "*")

        guard let id = Int(parsedInfo[1]) else {
            log("ID not converted!")
            return nil
        }
        let title = String(parsedInfo[2])
        let description = String(parsedInfo[3])
        guard let eventState = EventState(rawValue: String(parsedInfo[4])) else {
            log("StateEvent not converted")
            return nil
        }
        guard let score = Int(parsedInfo[5]) else {
            log("Score not converted")
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
            eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager()),
            settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager()),
            loginViewModel: LoginViewModel(networkManager: FakeNetworkManager()),
            pointsViewModel: PointsViewModel(networkManager: FakeNetworkManager()),
            leaderboardViewModel: LeaderboardViewModel(networkManager: FakeNetworkManager()),
            mapViewModel: MapViewModel(),
            notificationsViewModel: NotificationsViewModel(networkManager: FakeNetworkManager())
        ),
        log: { message in
            #if DEBUG
                print(message)
            #endif
        }
    )
    .environment(\.locale, .init(identifier: "ru"))
}
