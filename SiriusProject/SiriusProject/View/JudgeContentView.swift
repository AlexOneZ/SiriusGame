//
//  JudgeContentView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 31.03.2025.
//

import SwiftUI

struct JudgeContentView: View {
    var appViewModel: AppViewModel
    private let log: (String) -> Void
    // delete it
    @State var isNotificationViewShowing: Bool = false

    init(appViewModel: AppViewModel, log: @escaping (String) -> Void = { message in
        #if DEBUG
            print(message)
        #endif
    }) {
        self.appViewModel = appViewModel
        self.log = log
    }

    var body: some View {
        TabView {
            EventsListView(eventsListViewModel: appViewModel.eventsListViewModel, isNotificationViewShowing: $isNotificationViewShowing)
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
