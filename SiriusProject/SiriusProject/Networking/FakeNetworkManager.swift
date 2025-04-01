//
//  FakeNetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

struct FakeNetworkManager: NetworkManagerProtocol {
    func getTeams(logging: @escaping Logging = emptyLogging, completion: @escaping ([Team]) -> Void) {
        logging("Fetching teams")
        completion([Team(id: 0, name: "HSE FCS", score: 100),
                    Team(id: 1, name: "team 1", score: 55),
                    Team(id: 2, name: "team 2", score: 99),
                    Team(id: 3, name: "team 3", score: 76),
                    Team(id: 4, name: "team 4", score: 54),
                    Team(id: 5, name: "team 5", score: 21),
                    Team(id: 6, name: "team 6", score: 65),
                    Team(id: 7, name: "team 7", score: 43)])
    }

    func enterTeam(name: String, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func getTeam(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Team?) -> Void) {
        logging("Fetching team with ID: \(teamId)")
        completion(Team(id: teamId, name: "Fake Team", score: 10))
    }

    func updateTeamName(teamId: Int, name: String, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        logging("Updating team ID \(teamId) with new name: \(name)")
        completion(true)
    }

    func deleteTeam(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        logging("Deleting team with ID: \(teamId)")
        completion(true)
    }

    func getTeamEvents(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping ([Event]) -> Void) {
        logging("Fetching events for team ID: \(teamId)")
        completion([
            Event(id: 1, title: "Хоккей", description: "Игра в хоккей", state: .done, score: 3, adress: "Ледовая аренда", rules: "матч состоит из трех периодов продолжительностью 20 минут. Между периодами команды уходят на 15-минутный перерыв и меняются воротами период начинается с вбрасывания шайбы на поле. Об окончании периода свидетельствует свисток главного судьи; цель игры – забросить большее количество шайб в ворота соперника. Если по истечении основного времени счет будет равным, игра переходит в овертайм; длительность овертайма составляет 5 минут, команды играют в формате три на три. Если победитель не определится в овертайме, назначаются штрафные послематчевые броски (буллиты)"),
            Event(id: 2, title: "Футбол", description: "Игра в футбол", state: .now, score: 0, adress: "Футбольное поле", rules: "Игра по стандартным правилам FIFA"),
            Event(id: 3, title: "Гольф", description: "Игра в гольф", state: .next, score: 0, adress: "Гольф-клуб", rules: "18 лунок, правила R&A"),
            Event(id: 4, title: "Шашки", description: "Игра в шашки", state: .next, score: 0, adress: "Игровой клуб", rules: "Классические русские шашки")
        ])
    }

    func setTeamEventScore(teamId: Int, score: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        logging("Setting score \(score) for team ID: \(teamId)")
        completion(true)
    }

    func addEvent(name: String, description: String?, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        logging("Adding event: \(name) with description: \(description ?? "No description")")
        completion(true)
    }

    func deleteEvent(eventId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        logging("Deleting event with ID: \(eventId)")
        completion(true)
    }
}
