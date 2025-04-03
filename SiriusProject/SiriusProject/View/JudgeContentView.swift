//
//  JudgeContentView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 31.03.2025.
//

import SwiftUI

struct JudgeContentView: View {
    var appViewModel: AppViewModel
    private let logging: Logging
    // delete it
    @State var isNotificationViewShowing: Bool = false

    init(appViewModel: AppViewModel, logging: @escaping Logging) {
        self.appViewModel = appViewModel
        self.logging = logging
    }

    var body: some View {
        TabView {
            EventsListView(eventsListViewModel: appViewModel.eventsListViewModel, isNotificationViewShowing: $isNotificationViewShowing)
                .tabItem {
                    Image(systemName: "rectangle.on.rectangle")
                    Text("events")
                }
            SettingsView(settingsViewModel: appViewModel.settingsViewModel, logging: logging)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
    }
}
