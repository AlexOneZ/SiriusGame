//
//  ContentView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 25.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("somekey")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "en"))
}
