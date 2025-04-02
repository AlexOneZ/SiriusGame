//
//  ErrorPublisher.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 02.04.2025.
//

import SwiftUI

class ErrorPublisher: ObservableObject {
    @Published var errorMessage: ErrorMessage?

    func reportError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = ErrorMessage(message: message)
        }
    }
}

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}
