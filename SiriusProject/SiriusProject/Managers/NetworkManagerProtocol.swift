//
//  NetworkManagerProtocol.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 27.03.2025.
//

protocol NetworkManagerProtocol {
    func getAllEvents() -> [Event]

    func setScore(for eventId: Int, PIN: String)

    func logIn(name: String)

    func getTeamName() -> String

    func changeName(_ newName: String)

    func logOut()

    func getTeams() -> [Team]
}
