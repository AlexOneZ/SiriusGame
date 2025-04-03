//
//  NetworkManagerProtocol.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

protocol NetworkManagerProtocol {
    var logging: Logging { get }
    var token: String { get set }

    func getTeams(completion: @escaping ([Team]) -> Void)
    func enterTeam(name: String, completion: @escaping (Int) -> Void)
    func getTeam(teamId: Int, completion: @escaping (Team?) -> Void)
    func updateTeamName(teamId: Int, name: String, completion: @escaping (Bool) -> Void)
    func deleteTeam(teamId: Int, completion: @escaping (Bool) -> Void)
    func getTeamEvents(teamId: Int, completion: @escaping ([Event]) -> Void)
    func setTeamEventScore(teamId: Int, score: Int, completion: @escaping (Bool) -> Void)

    func addEvent(name: String, description: String, location: String, latidude: Double, longitude: Double, completion: @escaping (Bool) -> Void)
    func deleteEvent(eventId: Int, completion: @escaping (Bool) -> Void)
    func sendTokenToServer(token: String, completion: @escaping (Bool) -> Void)
    func getHistoryNotifications(token: String, completion: @escaping ([Notification]) -> Void)

    func deleteAllTeams(completion: @escaping (Bool) -> Void)
}
