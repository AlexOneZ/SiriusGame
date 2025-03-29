//
//  NotificationsView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct NotificationsView: View {
    var header: LocalizedStringKey = "notifications"
    
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
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        Group {
                            // здесь потом будут настоящие пуши
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                            NotificationCell(notification: MockData.sampleNotification)
                        }
                    }
                    .padding()
                }
                
            }
            .navigationTitle(header)
            .toolbarBackground(
                Color.white,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    NotificationsView()
}
