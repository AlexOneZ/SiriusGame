//
//  NotificationsView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel: NotificationsViewModel
    var header: LocalizedStringKey = "notifications"

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack (spacing: 4) {
                    Group {
                        ForEach(viewModel.notifications.indices, id: \.self) { index in
                            NotificationCell(notification: viewModel.notifications[index])
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 15)
                }
            }
            .navigationTitle(header)
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
    NotificationsView(viewModel: NotificationsViewModel(networkManager: FakeNetworkManager()))
}
