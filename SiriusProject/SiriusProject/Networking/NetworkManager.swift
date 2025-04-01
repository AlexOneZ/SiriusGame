//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

struct NetworkManager: NetworkManagerProtocol {
    private let service: APIService
    let logging: Logging

    init(service: APIService, logging: @escaping Logging) {
        self.service = service
        self.logging = logging
    }

    func getTeams(logging: @escaping Logging, completion: @escaping ([Team]) -> Void) {
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

    func enterTeam(name: String, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.enterTeam(name: name).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: [Team].self, logging: logging) { _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }

    func getTeam(teamId: Int, logging: @escaping Logging, completion: @escaping (Team?) -> Void) {
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

    func updateTeamName(teamId: Int, name: String, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
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

    func deleteTeam(teamId: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
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

    func getTeamEvents(teamId: Int, logging: @escaping Logging, completion: @escaping ([Event]) -> Void) {
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

    func setTeamEventScore(teamId: Int, score: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.getEvents().request else {
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

    func getEvents(logging: @escaping Logging, completion: @escaping ([Event]) -> Void) {
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

    func addEvent(name: String, description: String?, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.addEvent(name: name, description: description).request else {
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

    func deleteEvent(eventId: Int, logging: @escaping Logging, completion: @escaping (Bool) -> Void) {
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
}
