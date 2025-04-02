//
//  EventCard.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

import SwiftUI

struct EventCard: View {
    var appViewModel: AppViewModel
    @State var flip: Bool = false
    let event: Event
    @Binding var isNeedUpdate: Bool
    var body: some View {
        ZStack {
            EventCardFrontSide(event: event, flip: $flip)
                .rotation3DEffect(.degrees(flip ? 90 : 0), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear : .linear.delay(0.35), value: flip)
            EventCardBackSide(appViewModel: appViewModel, event: event, flip: $flip, isNeedUpdate: $isNeedUpdate)
                .rotation3DEffect(.degrees(flip ? 0 : -90), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear.delay(0.35) : .linear, value: flip)
        }
        .onTapGesture {
            flip.toggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

