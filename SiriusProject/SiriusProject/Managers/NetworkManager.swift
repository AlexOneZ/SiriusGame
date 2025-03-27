//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct FakeNetworkManager: NetworkManagerProtocol {
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
    
    //MARK: Teams
    
    func getTeams() -> [Team] {
        return [ Team(id: 0, name: "HSE FCS", score: 100),
                 Team(id: 1, name: "team 1", score: 55),
                 Team(id: 2, name: "team 2", score: 99),
                 Team(id: 3, name: "team 3", score: 76),
                 Team(id: 4, name: "team 4", score: 54),
                 Team(id: 5, name: "team 5", score: 21),
                 Team(id: 6, name: "team 6", score: 65),
                 Team(id: 7, name: "team 7", score: 43)]
    }
}
