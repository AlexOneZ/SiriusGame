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
    var description: String
    var state: EventState
    var score: Int
    var adress: String?
    var rules: String?
}
