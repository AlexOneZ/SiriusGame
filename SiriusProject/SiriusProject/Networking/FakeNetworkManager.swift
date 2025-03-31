//
//  FakeNetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

struct FakeNetworkManager: NetworkManagerProtocol {
    func getTeams(completion: @escaping ([Team]) -> Void) {
        completion([Team(id: 1, name: "Team A"), Team(id: 2, name: "Team B")])
    }

    func enterTeam(name: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func getTeam(teamId: Int, completion: @escaping (Team?) -> Void) {
        completion(Team(id: teamId, name: "Fake Team"))
    }

    func updateTeamName(teamId: Int, name: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func deleteTeam(teamId: Int, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func getTeamEvents(teamId: Int, completion: @escaping ([Event]) -> Void) {
        completion([
            Event(id: 1, title: "Хоккей", description: "Игра в хоккей", state: .done, score: 3),
            Event(id: 2, title: "Футбол", description: "Игра в футбол", state: .now, score: 0),
            Event(id: 3, title: "Гольф", description: "Игра в гольф", state: .next, score: 0),
            Event(id: 4, title: "Шашки", description: "Игра в шашки", state: .next, score: 0)
        ])
    }

    func setTeamEventScore(teamId: Int, score: Int, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func addEvent(name: String, description: String?, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func deleteEvent(eventId: Int, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
