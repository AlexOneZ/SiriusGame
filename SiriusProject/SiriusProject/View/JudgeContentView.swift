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
    @State var isNotificationViewShowing: Bool = false

    init(appViewModel: AppViewModel, logging: @escaping Logging) {
        self.appViewModel = appViewModel
        self.logging = logging
    }

    var body: some View {
        TabView {
            SendReviewToUserView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Поставить оценку")
                }
            CreateEventView(viewModel: appViewModel.createEventViewModel)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("createevent")
                }

            SettingsView(settingsViewModel: appViewModel.settingsViewModel, logging: logging)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings")
                }
        }
    }
}
