//
//  EventCard.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

import SwiftUI

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(event.id)")
                    .padding()
                    .background {
                        Circle()
                            .foregroundStyle(Color(.systemGray5))
                    }
                Text(event.title)
            }
            HStack {
                Circle()
                    .foregroundStyle(event.state.getColor())
                    .frame(width: 10)
                if let description = event.state.getDescription() {
                    Text(description)
                } else {
                    Text("score") + Text(": \(event.score)")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.systemGray5))
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(.horizontal)
        
    }
}
