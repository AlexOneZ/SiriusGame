//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

@Observable
class NetworkManager {
    // MARK: Events

    func getAllEvents() -> [Event] {
        return [
            Event(id: 1, title: "Хоккей", description: "Игра в хоккей", state: .done, score: 3),
            Event(id: 2, title: "Футбол", description: "Игра в футбол", state: .now, score: 0),
            Event(id: 3, title: "Гольф", description: "Игра в гольф", state: .next, score: 0),
            Event(id: 4, title: "Шашки", description: "Игра в шашки", state: .next, score: 0)
        ]
    }

    func setScore(for eventId: Int, PIN: String) {}

    // MARK: Team managment

    func logIn(name: String) {}

    func getTeamName() -> String {
        "Team"
    }

    func changeName(_ newName: String) {}

    func logOut() {}
}
