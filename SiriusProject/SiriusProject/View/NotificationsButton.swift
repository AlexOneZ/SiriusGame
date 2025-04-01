//
//  NotificationsButton.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 31.03.2025.
//

import SwiftUI

struct NotificationsButton: View {
    var body: some View {
        Circle()
            .fill(Color("NotificationColor"))
            .frame(width: 75, height: 75)
            .overlay(
                Image(systemName: "ellipsis.message")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                )
    }
}

#Preview {
    NotificationsButton()
}
