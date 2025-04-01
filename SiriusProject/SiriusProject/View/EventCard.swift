//
//  EventCard.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

import SwiftUI

struct EventCard: View {
    @State var flip: Bool = false
    @Binding var show: Bool
    let event: Event
    var body: some View {
        ZStack {
            EventCardFrontSide(event: event, flip: $flip)
                .rotation3DEffect(.degrees(flip ? 90 : 0), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear : .linear.delay(0.35), value: flip)
            EventCardBackSide(event: event, flip: $flip, showRate: $show)
                .rotation3DEffect(.degrees(flip ? 0 : -90), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear.delay(0.35) : .linear, value: flip)
        }
        .onTapGesture {
            flip.toggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EventCard(
        show: .constant(false),
        event: FakeNetworkManager().getAllEvents().first!
    )
}
