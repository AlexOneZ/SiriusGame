//
//  EventState.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

import SwiftUI

enum EventState: String {
    case done
    case now
    case next

    func getColor() -> Color {
        switch self {
        case .done:
            Color.gray
        case .now:
            Color.green
        case .next:
            Color.red
        }
    }

    func getDescription() -> LocalizedStringKey? {
        switch self {
        case .done:
            nil
        case .now:
            "now"
        case .next:
            "next"
        }
    }
}
