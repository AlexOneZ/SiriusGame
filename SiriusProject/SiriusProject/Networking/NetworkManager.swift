//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

struct NetworkManager: NetworkManagerProtocol {
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }

    func getTeams(logging: @escaping Logging = emptyLogging, completion: @escaping ([Team]) -> Void) {
        guard let request = Endpoint.getTeams().request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Team].self) { teams, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(teams ?? [])
        }
    }

    func enterTeam(name: String, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.enterTeam(name: name).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: [Team].self) { _, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }

    func getTeam(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Team?) -> Void) {
        guard let request = Endpoint.getTeam(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion(nil)
            return
        }

        service.makeRequest(with: request, respModel: Team.self) { team, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(nil)
                return
            }

            completion(team)
        }
    }

    func updateTeamName(teamId: Int, name: String, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.updateTeamName(teamId: teamId, name: name).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Team.self) { team, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(team != nil)
        }
    }

    func deleteTeam(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.deleteTeam(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func getTeamEvents(teamId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping ([Event]) -> Void) {
        guard let request = Endpoint.getTeamEvents(teamId: teamId).request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Event].self) { events, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func setTeamEventScore(teamId: Int, score: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.getEvents().request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }

            completion(success ?? false)
        }
    }

    func getEvents(logging: @escaping Logging = emptyLogging, completion: @escaping ([Event]) -> Void) {
        guard let request = Endpoint.getEvents().request else {
            logging("Error: Failed to create request")
            completion([])
            return
        }

        service.makeRequest(with: request, respModel: [Event].self) { events, error in
            if let error = error {
                logging(error.localizedDescription)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func addEvent(name: String, description: String?, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.addEvent(name: name, description: description).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func deleteEvent(eventId: Int, logging: @escaping Logging = emptyLogging, completion: @escaping (Bool) -> Void) {
        guard let request = Endpoint.deleteEvent(eventId: eventId).request else {
            logging("Error: Failed to create request")
            completion(false)
            return
        }

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                logging(error.localizedDescription)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }
}
