//
//  SportIconProvider.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 02.04.2025.
//

import Foundation

enum SportIconProvider {
    static func getSportIcon(for eventName: String) -> String {
        switch eventName.lowercased() {
        case "футбол": return "soccerball"
        case "американский футбол": return "american.football"
        case "баскетбол": return "basketball.fill"
        case "волейбол": return "volleyball"
        case "теннис": return "tennis.racket"
        case "бадминтон": return "figure.badminton"
        case "хоккей": return "figure.hockey"
        case "гольф": return "figure.golf"
        case "плавание": return "figure.pool.swim"
        case "велоспорт": return "figure.cycling"
        case "бег", "марафон": return "figure.run"
        case "гребля": return "figure.outdoor.rowing"
        case "лыжи": return "figure.indoor.rowing"
        case "сноуборд": return "figure.snowboarding"
        case "коньки": return "figure.ice.skating"
        case "серфинг": return "figure.surfing"
        case "стрельба из лука": return "target"
        case "фехтование": return "figure.fencing"
        case "бокс": return "figure.boxing"
        case "дзюдо", "карате", "таэквондо", "самбо", "борьба":
            return "figure.martial.arts"
        case "тяжелая атлетика", "пауэрлифтинг":
            return "dumbbell"
        case "гимнастика": return "figure.gymnastics"
        case "йога": return "figure.yoga"
        case "автоспорт", "формула 1": return "car"
        case "мотоциклы", "мотоспорт": return "motorcycle"
        case "скейтбординг": return "figure.skateboarding"
        case "прыжки в длину", "прыжки в высоту": return "figure.track.and.field"
        case "шахматы": return "rectangle.pattern.checkered"
        case "регби": return "figure.rugby"
        case "скалолазание": return "figure.climbing"
        case "": return "flag.pattern.checkered"
        default: return "trophy.fill"
        }
    }

    static func getSportIconCircle(for eventName: String) -> String {
        switch eventName.lowercased() {
        case "футбол": return "soccerball"
        case "американский футбол": return "american.football.circle"
        case "баскетбол": return "basketball.fill"
        case "волейбол": return "volleyball"
        case "теннис": return "tennis.racket"
        case "бадминтон": return "figure.badminton"
        case "хоккей": return "figure.hockey.circle"
        case "гольф": return "figure.golf.circle"
        case "плавание": return "figure.pool.swim.circle"
        case "велоспорт": return "figure.cycling.circle"
        case "бег", "марафон": return "figure.run.circle"
        case "гребля": return "figure.outdoor.rowing.circle"
        case "лыжи": return "figure.indoor.rowing.circle"
        case "сноуборд": return "figure.snowboarding.circle"
        case "коньки": return "figure.ice.skating.circle"
        case "серфинг": return "figure.surfing.circle"
        case "стрельба из лука": return "target.circle"
        case "фехтование": return "figure.fencing.circle"
        case "бокс": return "figure.boxing.circle"
        case "дзюдо", "карате", "таэквондо", "самбо", "борьба":
            return "figure.martial.arts.circle"
        case "тяжелая атлетика", "пауэрлифтинг":
            return "dumbbell.circle"
        case "гимнастика": return "figure.gymnastics.circle"
        case "йога": return "figure.yoga.circle"
        case "автоспорт", "формула 1": return "car"
        case "мотоциклы", "мотоспорт": return "motorcycle"
        case "скейтбординг": return "figure.skateboarding.circle"
        case "прыжки в длину", "прыжки в высоту": return "figure.track.and.field.circle"
        case "шахматы": return "rectangle.pattern.checkered"
        case "регби": return "figure.rugby.circle"
        case "скалолазание": return "figure.climbing.circle"
        default: return "trophy.fill"
        }
    }
}
