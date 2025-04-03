//
//  NotificationCell.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 29.03.2025.
//

import SwiftUI

struct NotificationCell: View {
    var notification: Notification

    var body: some View {
        VStack(alignment: .leading) {
            Text(notification.title)
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(Color("SiriusDarkColor").opacity(0.9))
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(notification.body)
                .foregroundColor(Color("SiriusDarkColor").opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .containerRelativeFrame(.horizontal) { width, _ in width * 0.85 }
        .background(.white)
        .cornerRadius(15)
    }
}

#Preview {
    NotificationCell(notification: .init(title: "Test", body: "Test", date: Date()))
}
