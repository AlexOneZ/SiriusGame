//
//  ErrorHandlerView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 02.04.2025.
//

import SwiftUI

struct ErrorHandlerView<Content: View>: View {
    @ObservedObject var errorPublisher: ErrorPublisher
    @State private var errorMessage: ErrorMessage?
    let content: Content

    init(errorPublisher: ErrorPublisher, @ViewBuilder content: () -> Content) {
        self.errorPublisher = errorPublisher
        self.content = content()
    }

    var body: some View {
        content
            .onReceive(errorPublisher.$errorMessage) { newValue in
                errorMessage = newValue
            }
            .alert(item: $errorMessage) { error in
                Alert(title: Text("Ошибка"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
    }
}
