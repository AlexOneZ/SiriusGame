//
//  LockScreenActivityView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 04.04.2025.
//

import SwiftUI

struct LockScreenActivityView: View {
    @State var eventName: String = ""
    @State var currentEventState: EventState = .now
    @State var status: String = ""
    @State var nextEventName: String = "Гольф"
    @State var nextEventStatus: EventState = .next
    @State var score: Int = 0
    var body: some View {
        VStack {
            HStack {
                Image(systemName: SportIconProvider.getSportIcon(for: eventName))
                    .font(.title)
                if !eventName.isEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(eventName)
                                .font(.headline)
                                .bold()
                            Circle()
                                .foregroundStyle(currentEventState.getColor())
                                .frame(width: 10)
                            Text("\(status)")
                        }

                        HStack {
                            Text(nextEventName)
                                .font(.footnote)
                            Circle()
                                .font(.footnote)
                                .foregroundStyle(nextEventStatus.getColor())
                                .frame(width: 7)
                            Text("\(nextEventStatus)")
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal)

                } else {
                    Text("finishevents")
                        .font(.headline)
                        .padding(.horizontal)
                }

                Spacer()

                Text("Score: \(score)")
                    .font(.headline)
                    .bold()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    LockScreenActivityView()
}
