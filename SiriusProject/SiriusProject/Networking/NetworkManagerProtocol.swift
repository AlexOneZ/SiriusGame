//
//  NetworkManagerProtocol.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

protocol NetworkManagerProtocol {
    func getTeams(logging: @escaping Logging, completion: @escaping ([Team]) -> Void)
    func enterTeam(name: String, logging: @escaping Logging, completion: @escaping (Bool) -> Void)
    func getTeam(teamId: Int, logging: @escaping Logging, completion: @escaping (Team?) -> Void)
    func updateTeamName(teamId: Int, name: String, logging: @escaping Logging, completion: @escaping (Bool) -> Void)
    func deleteTeam(teamId: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void)
    func getTeamEvents(teamId: Int, logging: @escaping Logging, completion: @escaping ([Event]) -> Void)
    func setTeamEventScore(teamId: Int, score: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void)

    func addEvent(name: String, description: String?, logging: @escaping Logging, completion: @escaping (Bool) -> Void)
    func deleteEvent(eventId: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void)
}
