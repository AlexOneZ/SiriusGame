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
        event: Event(id: 1, title: "Хоккей", description: "Игра в хоккей", state: .done, score: 3, adress: "Ледовая аренда", rules: "матч состоит из трех периодов продолжительностью 20 минут. Между периодами команды уходят на 15-минутный перерыв и меняются воротами период начинается с вбрасывания шайбы на поле. Об окончании периода свидетельствует свисток главного судьи; цель игры – забросить большее количество шайб в ворота соперника. Если по истечении основного времени счет будет равным, игра переходит в овертайм; длительность овертайма составляет 5 минут, команды играют в формате три на три. Если победитель не определится в овертайме, назначаются штрафные послематчевые броски (буллиты)"),
        flip: .constant(false),
        height: 90
    )
}
