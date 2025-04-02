//
//  NotificationsView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct NotificationsView: View {
    @Binding var isNotificationViewShowing: Bool
    @ObservedObject var viewModel: NotificationsViewModel
    var header: LocalizedStringKey = "notifications"

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 4) {
                    Group {
                        ForEach(viewModel.notifications.indices, id: \.self) { index in
                            NotificationCell(notification: viewModel.notifications[index])
                        }
                    }
                    .padding(.top, 13)
                }
            }
            .navigationTitle(header)
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("SiriusDarkColor").opacity(0.5),
                        Color("SiriusDarkColor").opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .toolbarBackground(
                Color.white,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    NotificationsView(
        isNotificationViewShowing: .constant(true),
        viewModel: NotificationsViewModel(networkManager: FakeNetworkManager(logging: printLogging))
    )
}
