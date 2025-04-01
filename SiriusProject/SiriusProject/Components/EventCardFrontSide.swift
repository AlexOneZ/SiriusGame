//
//  EventCardFrontSide.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

struct EventCardFrontSide: View {
    let event: Event
    @Binding var flip: Bool
    @State var height: CGFloat = 90

    var body: some View {
        VStack(alignment: .leading) {
            EventOrderTitle(
                orderNumber: event.id,
                title: event.title
            )

            EventStateViewComponent(
                eventState: event.state,
                score: event.score,
                height: $height
            )
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(.horizontal)
        .onChange(of: flip) {
            withAnimation(.easeInOut(duration: 1)) {
                height = flip ? .infinity : 90
            }
        }
    }
}

#Preview {
    EventCardFrontSide(
        event: FakeNetworkManager().getAllEvents().first!,
        flip: .constant(false),
        height: 90
    )
}
