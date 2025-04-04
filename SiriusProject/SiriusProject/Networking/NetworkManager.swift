//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import Foundation
import SwiftUI

struct NetworkManager: NetworkManagerProtocol {
    private let service: APIService
    let logging: Logging
    @AppStorage("notificationsToken") var token: String = ""

    init(service: APIService, logging: @escaping Logging) {
        self.service = service
        self.logging = logging
    }

    func getTeams(completion: @escaping ([Team]) -> Void) {
        guard let request = Endpoint.getTeams().request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Team].self, logging: logging) { teams, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(teams ?? [])
        }
    }

    func enterTeam(name: String, completion: @escaping (Int) -> Void) {
        guard let request = Endpoint.enterTeam(name: name).request else {
            logging("Error: Failed to create request")
            completion(0)
            return
        }

        service.makeRequest(with: request, respModel: EnterTeamResponse.self, logging: logging) { enterTeamResponse, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(0)
                return
            }
            completion(enterTeamResponse?.team_id ?? 0)
        }
    }

    func getTeam(teamId: Int, completion: @escaping (Team?) -> Void) {
        guard let request = Endpoint.getTeam(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion(nil)
            return
        }

        service.makeRequest(with: request, respModel: Team.self, logging: logging) { team, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(nil)
                return
            }

            completion(team)
        }
    }

    func updateTeamName(teamId: Int, name: String, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.updateTeamName(teamId: teamId, name: name).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Team.self, logging: logging) { team, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(team != nil)
        }
    }

    func deleteTeam(teamId: Int, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.deleteTeam(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self, logging: logging) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func getTeamEvents(teamId: Int, completion: @escaping ([Event]) -> Void) {
        guard let request = Endpoint.getTeamEvents(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Event].self, logging: logging) { events, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func setTeamEventScore(teamId: Int, score: Int, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.setTeamEventScore(teamId: teamId, score: score).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self, logging: logging) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }

            completion(success ?? false)
        }
    }

    func getEvents(completion: @escaping ([Event]) -> Void) {
        guard let request = Endpoint.getEvents().request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Event].self, logging: logging) { events, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func addEvent(name: String, description: String, location: String, latidude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.addEvent(name: name, description: description, location: location, latidude: latidude, longitude: longitude).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: EventAddResponse.self, logging: logging) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success != nil)
        }
    }

    func deleteEvent(eventId: Int, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.deleteEvent(eventId: eventId).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self, logging: logging) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func sendTokenToServer(token: String, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.sendTokenToServer(token: token).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }

    func getHistoryNotifications(token: String, completion: @escaping ([Notification]) -> Void) {
        guard let request = Endpoint.getHistoryNotifications(token: token).request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }
        service.makeRequest(with: request, respModel: [Notification].self, logging: logging) { notifications, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }
            completion(notifications ?? [])
        }
    }

    func deleteAllTeams(completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.deleteAllTeams().request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }

    func sendPushesToAll(teamname: String, score: Int, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.sendPushesToAll(teamname: teamname, score: score).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }

    func sendTextPushesToAll(text: String, title: String, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.sendTextPushesToAll(text: text, title: title).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Data.self, logging: logging) { response, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(response != nil)
        }
    }
}
