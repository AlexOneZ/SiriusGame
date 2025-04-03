//
//  Notification.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct Notification: Codable {
    let title: String
    let body: String
    let date: Date?

    init(title: String, body: String, date: Date) {
        self.title = title
        self.body = body
        self.date = date
    }

    init(notificationRequest: NotificationRequest) {
        title = notificationRequest.title
        body = notificationRequest.body
        let isoDate = notificationRequest.sent_at

        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        date = isoDateFormatter.date(from: isoDate)
    }
}

struct NotificationRequest: Codable {
    let title: String
    let body: String
    let sent_at: String
}
