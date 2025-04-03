//
//  NotificationsView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct NotificationsView: View {
    private let log: (String) -> Void
    @Binding var isNotificationViewShowing: Bool
    @ObservedObject var viewModel: NotificationsViewModel
    var header: LocalizedStringKey = "notifications"

    init(
        notificationsViewModel: NotificationsViewModel,
        isNotificationViewShowing: Binding<Bool>,
        log: @escaping (String) -> Void
    ) {
        viewModel = notificationsViewModel
        _isNotificationViewShowing = isNotificationViewShowing
        self.log = log
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("SiriusDarkColor").opacity(0.5),
                        Color("SiriusDarkColor").opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else if viewModel.notifications.isEmpty {
                    Text("nonotifications")
                        .foregroundStyle(.placeholder)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                }
                else {
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
                }
            }
            .navigationTitle(header)
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.getHistoryNotifications()
            }
            .toolbarBackground(
                Color.white,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            viewModel.getHistoryNotifications()
        }
    }
}
