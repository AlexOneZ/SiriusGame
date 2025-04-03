//
//  EventCardBackSide.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

import SwiftUI

struct EventCardBackSide: View {
    var appViewModel: AppViewModel
    let event: Event
    @State var animate: Bool = false
    @Binding var flip: Bool
    @State var height: CGFloat = 90
    @State var show: Bool = false
    @State var detailsOpacity: CGFloat = 1

    @AppStorage("isJudge") var isJudge: Bool = false

    @State var isPresentedJudgeScreen: Bool = false
    @State var presentedEventForUser: Event? = nil
    @Binding var isNeedUpdate: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                EventOrderTitle(orderNumber: event.id, title: event.title)

                Spacer()

                Circle()
                    .foregroundStyle(event.state.getColor())
                    .frame(width: 10)
                if let description = event.state.getDescription() {
                    Text(description)
                } else {
                    Text("score") + Text(": \(event.score)")
                }
            }

            if show {
                VStack(alignment: .leading) {
                    EventInfoBlockViewComponent(
                        title: NSLocalizedString("location", comment: "Местоположение"),
                        description: event.address,
                        hide: $show
                    )

                    EventInfoBlockViewComponent(
                        title: NSLocalizedString("rules", comment: "Правила игры"),
                        description: event.description,
                        hide: $show
                    )

                    if event.state == EventState.now {
                        Button {
                            if isJudge {
                                isPresentedJudgeScreen = true
                            } else {
                                presentedEventForUser = event
                            }

                        } label: {
                            Text(isJudge ? "sendscore" : "getscore")
                                .foregroundStyle(.white)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.siriusPurple2))
                                .cornerRadius(20)
                        }
                    }
                }
                .sheet(item: $presentedEventForUser) { event in
                    GetReviewView(
                        event: event,
                        getReviewViewModel: appViewModel.getRateReviewModel,
                        isNeedUpdate: $isNeedUpdate
                    )
                }
                .sheet(isPresented: $isPresentedJudgeScreen) {
                    SendReviewToUserView(event: event)
                }
                .opacity(detailsOpacity)
                .transition(.opacity)
            }
        }
        .frame(maxHeight: height)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.siriusBlue, .siriusBlue]), startPoint: .topLeading, endPoint: .topLeading)
                )
        }
        .padding(.horizontal)
        .onChange(of: flip) {
            withAnimation(.easeInOut(duration: 1)) {
                height = flip ? .infinity : 90
            }

            withAnimation(.easeInOut(duration: 0.5)) {
                detailsOpacity = flip ? 1 : 0
                show.toggle()
            }
        }
    }
}
