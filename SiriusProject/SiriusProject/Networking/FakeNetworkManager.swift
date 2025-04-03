//
//  FakeNetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

import SwiftUI

struct FakeNetworkManager: NetworkManagerProtocol {
    let logging: Logging
    var token: String = ""

    init(logging: @escaping Logging) {
        self.logging = logging
    }

    func getTeams(completion: @escaping ([Team]) -> Void) {
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

    func enterTeam(name: String, completion: @escaping (Int) -> Void) {
        completion(1)
    }

    func getTeam(teamId: Int, completion: @escaping (Team?) -> Void) {
        logging("Fetching team with ID: \(teamId)")
        completion(Team(id: teamId, name: "Fake Team", score: 10))
    }

    func updateTeamName(teamId: Int, name: String, completion: @escaping (Bool) -> Void) {
        logging("Updating team ID \(teamId) with new name: \(name)")
        completion(true)
    }

    func deleteTeam(teamId: Int, completion: @escaping (Bool) -> Void) {
        logging("Deleting team with ID: \(teamId)")
        completion(true)
    }

    func getTeamEvents(teamId: Int, completion: @escaping ([Event]) -> Void) {
        logging("Fetching events for team ID: \(teamId)")
        completion([
            Event(id: 1, title: "Хоккей", state: .done, score: 3, address: "Ледовая аренда", description: "матч состоит из трех периодов продолжительностью 20 минут. Между периодами команды уходят на 15-минутный перерыв и меняются воротами период начинается с вбрасывания шайбы на поле. Об окончании периода свидетельствует свисток главного судьи; цель игры – забросить большее количество шайб в ворота соперника. Если по истечении основного времени счет будет равным, игра переходит в овертайм; длительность овертайма составляет 5 минут, команды играют в формате три на три. Если победитель не определится в овертайме, назначаются штрафные послематчевые броски (буллиты)", latitude: 43.40249662803451, longitude: 39.951579184906024),
            Event(id: 2, title: "Футбол", state: .now, score: 0, address: "Футбольное поле", description: "Игра по стандартным правилам FIFA", latitude: 43.41401, longitude: 39.95086),
            Event(id: 3, title: "Гольф", state: .next, score: 0, address: "Гольф-клуб", description: "18 лунок, правила R&A", latitude: 43.40222213237247, longitude: 39.95576828887243),
            Event(id: 4, title: "Шашки", state: .next, score: 0, address: "Игровой клуб", description: "Классические русские шашки", latitude: 43.40856, longitude: 39.95196)
        ])
    }

    func setTeamEventScore(teamId: Int, score: Int, completion: @escaping (Bool) -> Void) {
        logging("Setting score \(score) for team ID: \(teamId)")
        completion(true)
    }

    func addEvent(name: String, description: String?, completion: @escaping (Bool) -> Void) {
        logging("Adding event: \(name) with description: \(description ?? "No description")")
        completion(true)
    }

    func deleteEvent(eventId: Int, completion: @escaping (Bool) -> Void) {
        logging("Deleting event with ID: \(eventId)")
        completion(true)
    }

    func sendTokenToServer(token: String, completion: @escaping (Bool) -> Void) {
        logging("Token: \(token)")
        completion(true)
    }

    func getHistoryNotifications(token: String, completion: @escaping ([Notification]) -> Void) {
        logging("Fetching events for token: \(token)")
        completion([
            Notification(
                title: "Регистрация команды",
                body: "Ваша команда успешно зарегистрирована! Можете приступать к игре!",
                date: Date()
            ),
            Notification(
                title: "Соревнование началось!",
                body: "Уважаемые участники! Соревнование по футболу уже началось!",
                date: Date()
            ),
            Notification(
                title: "Соревнование завершено!",
                body: "Уважаемые участники! Соревнование по футболу завершено! Вы набрали 7/10 баллов!",
                date: Date()
            ),
            Notification(
                title: "Соревнование началось!",
                body: "Уважаемые участники! Соревнование по хоккею уже началось!",
                date: Date()
            )
        ])
    }
}
