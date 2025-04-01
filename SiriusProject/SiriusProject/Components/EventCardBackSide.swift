//
//  EventCardBackSide.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

import SwiftUI

struct EventCardBackSide: View {
    let event: Event
    @State var animate: Bool = false
    @Binding var flip: Bool
    @State var height: CGFloat = 90
    @State var show: Bool = false
    @State var detailsOpacity: CGFloat = 1
    @Binding var showRate: Bool

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
                        description: event.adress ?? "",
                        hide: $show
                    )

                    EventInfoBlockViewComponent(
                        title: NSLocalizedString("rules", comment: "Правила игры"),
                        description: event.rules ?? "",
                        hide: $show
                    )

                    if event.state == EventState.now {
                        Button {
                            showRate.toggle()
                        } label: {
                            Text("getscore")
                                .foregroundStyle(.white)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.purple))
                                .cornerRadius(20)
                        }
                    }
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
                .foregroundStyle(Color(.systemGray3))
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

#Preview {
    EventCardBackSide(event: Event(id: 1, title: "Хоккей", description: "Игра в хоккей", state: .done, score: 3, adress: "Ледовая аренда", rules: "матч состоит из трех периодов продолжительностью 20 минут. Между периодами команды уходят на 15-минутный перерыв и меняются воротами период начинается с вбрасывания шайбы на поле. Об окончании периода свидетельствует свисток главного судьи; цель игры – забросить большее количество шайб в ворота соперника. Если по истечении основного времени счет будет равным, игра переходит в овертайм; длительность овертайма составляет 5 минут, команды играют в формате три на три. Если победитель не определится в овертайме, назначаются штрафные послематчевые броски (буллиты)"), flip: .constant(true), showRate: .constant(false))
}
