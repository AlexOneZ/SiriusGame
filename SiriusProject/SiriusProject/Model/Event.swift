//
//  Event.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct Event: Identifiable {
    let id: Int
    var title: String
    var state: EventState = .done
    var score: Int = 0
    var address: String
    var description: String
    var latitude: Double = 1.0
    var longitude: Double = 1.0
}

extension Event: Codable {
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case description
        case id = "order"
        case state
        case score
        case address = "location"
        case latitude = "latidude"
        case longitude
    }
}
