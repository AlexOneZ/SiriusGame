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
        .onOpenURL { url in
            let event = recieveDeeplinkURL(url: url)
            print(event?.id ?? -1, event?.title ?? "no title", event?.description ?? "no description", event?.state ?? EventState.now, event?.score ?? -100)
        }
    }

    private func recieveDeeplinkURL(url: URL) -> Event? {
        let infoFromURL = url.absoluteString
        let parsedInfo = infoFromURL.split(separator: "*")

        guard let id = Int(parsedInfo[1]) else {
            print("ID not converted!")
            return nil
        }
        let title = String(parsedInfo[2])
        let description = String(parsedInfo[3])
        guard let eventState = EventState(rawValue: String(parsedInfo[4])) else {
            print("StateEvent not converted")
            return nil
        }
        guard let score = Int(parsedInfo[5]) else {
            print("Score not converted")
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
    ContentView(appViewModel: AppViewModel(eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager()), settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager()), loginViewModel: LoginViewModel(networkManager: FakeNetworkManager()), pointsViewModel: PointsViewModel(networkManager: FakeNetworkManager()), notificationsViewModel: NotificationsViewModel(networkManager: FakeNetworkManager())))
        .environment(\.locale, .init(identifier: "ru"))
}
