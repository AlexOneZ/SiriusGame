//
//  EventStateViewComponent.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

struct EventStateViewComponent: View {
    let eventState: EventState
    let score: Int
    @Binding var height: CGFloat
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(eventState.getColor())
                .frame(width: 10)
            if let description = eventState.getDescription() {
                Text(description)
            } else {
                Text("score") + Text(": \(score)")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: height)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(.systemGray5))
        }
    }
}
