//
//  NetworkManager.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

struct NetworkManager: NetworkManagerProtocol {
    let service = APIService()

    func getTeams(completion: @escaping ([Team]) -> Void) {
        let request = Endpoint.getTeams().request!

        service.makeRequest(with: request, respModel: [Team].self) { teams, error in
            if let error = error {
                print(error)
                completion([])
                return
            }

            completion(teams ?? [])
        }
    }

    func enterTeam(name: String, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.enterTeam(name: name).request!

        service.makeRequest(with: request, respModel: [Team].self) { _, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            completion(true)
        }
    }

    func getTeam(teamId: Int, completion: @escaping (Team?) -> Void) {
        let request = Endpoint.getTeam(teamId: teamId).request!

        service.makeRequest(with: request, respModel: Team.self) { team, error in
            if let error = error {
                print(error)
                completion(nil)
                return
            }

            completion(team)
        }
    }

    func updateTeamName(teamId: Int, name: String, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.updateTeamName(teamId: teamId, name: name).request!

        service.makeRequest(with: request, respModel: Team.self) { team, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            completion(team != nil)
        }
    }

    func deleteTeam(teamId: Int, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.deleteTeam(teamId: teamId).request!

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func getTeamEvents(teamId: Int, completion: @escaping ([Event]) -> Void) {
        let request = Endpoint.getTeamEvents(teamId: teamId).request!

        service.makeRequest(with: request, respModel: [Event].self) { events, error in
            if let error = error {
                print(error)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func setTeamEventScore(teamId: Int, score: Int, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.getEvents().request!

        service.makeRequest(with: request, respModel: [Event].self) { teamEvent, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }

            completion(teamEvent != nil)
        }
    }

    func getEvents(completion: @escaping ([Event]) -> Void) {
        let request = Endpoint.getEvents().request!

        service.makeRequest(with: request, respModel: [Event].self) { events, error in
            if let error = error {
                print(error)
                completion([])
                return
            }

            completion(events ?? [])
        }
    }

    func addEvent(name: String, description: String?, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.addEvent(name: name, description: description).request!

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }

    func deleteEvent(eventId: Int, completion: @escaping (Bool) -> Void) {
        let request = Endpoint.deleteEvent(eventId: eventId).request!

        service.makeRequest(with: request, respModel: Bool.self) { success, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            completion(success ?? false)
        }
    }
}
