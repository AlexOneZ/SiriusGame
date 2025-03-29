//
//  Notification.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import SwiftUI

struct Notification {
    let title: String
    let body: String
}

enum MockData {
    static let sampleNotification = Notification(
        title: "Title",
        body: "This is a long long long text for myb test notofication to check what will be done if the message will be too long"
    )
}
