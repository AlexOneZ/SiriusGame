//
//  EventCard.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

import SwiftUI

struct EventCard: View {
    @State var flip: Bool = false
    let event: Event
    var body: some View {
        ZStack {
            EventCardFrontSide(event: event, flip: $flip)
                .rotation3DEffect(.degrees(flip ? 90 : 0), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear : .linear.delay(0.35), value: flip)
            EventCardBackSide(event: event, flip: $flip)
                .rotation3DEffect(.degrees(flip ? 0 : -90), axis: (x: 0.0001, y: 1, z: 0.0001))
                .animation(flip ? .linear.delay(0.35) : .linear, value: flip)
        }
        .onTapGesture {
            flip.toggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    EventCard(
//        event: Event(id: 1, title: "Хоккей", state: .done, score: 3, address: "Ледовая аренда", description: "матч состоит из трех периодов продолжительностью 20 минут. Между периодами команды уходят на 15-минутный перерыв и меняются воротами период начинается с вбрасывания шайбы на поле. Об окончании периода свидетельствует свисток главного судьи; цель игры – забросить большее количество шайб в ворота соперника. Если по истечении основного времени счет будет равным, игра переходит в овертайм; длительность овертайма составляет 5 минут, команды играют в формате три на три. Если победитель не определится в овертайме, назначаются штрафные послематчевые броски (буллиты)", latitude: 0.0, longitude: 0.0)
//    )
//}
