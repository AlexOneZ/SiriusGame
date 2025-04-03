//
//  Endpoint.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

import Foundation

enum Endpoint {
    case getTeams(url: String = Constants.teamsPath)
    case enterTeam(url: String = Constants.teamsPath, name: String)
    case getTeam(url: String = Constants.teamsPath, teamId: Int)
    case updateTeamName(url: String = Constants.teamsPath, teamId: Int, name: String)
    case deleteTeam(url: String = Constants.teamsPath, teamId: Int)
    case getTeamEvents(url: String = Constants.teamsPath, teamId: Int, url1: String = Constants.eventsPath)
    case setTeamEventScore(url: String = Constants.teamsPath, teamId: Int, url1: String = Constants.eventsPath, score: Int)

    case getEvents(url: String = Constants.eventsPath)
    case addEvent(url: String = Constants.eventsPath, name: String, description: String, location: String, latidude: Double, longitude: Double)
    case deleteEvent(url: String = Constants.eventsPath, eventId: Int)
    case sendTokenToServer(url: String = Constants.pushesPath, url1: String = Constants.registerPath, token: String)
    case getHistoryNotifications(url: String = Constants.pushesPath, url1: String = Constants.historyPath, token: String)

    var request: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValues(for: self)
        return request
    }

    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    private var path: String {
        switch self {
        case let .getTeams(url):
            return url
        case let .enterTeam(url, _):
            return url
        case let .getTeam(url, teamId):
            return "\(url)/\(teamId)"
        case let .updateTeamName(url, teamId, _):
            return "\(url)/\(teamId)"
        case let .deleteTeam(url, teamId):
            return "\(url)/\(teamId)"
        case let .getTeamEvents(url, teamId, url1):
            return "\(url)/\(teamId)\(url1)"
        case let .setTeamEventScore(url, teamId, url1, _):
            return "\(url)/\(teamId)\(url1)"
        case let .getEvents(url):
            return url
        case let .addEvent(url, name, description, location, latidude, longitude):
            return "\(url)"
        case let .deleteEvent(url, eventId):
            return "\(url)/\(eventId)"
        case let .sendTokenToServer(url, url1, _):
            return url + url1
        case let .getHistoryNotifications(url, url1, token):
            return "\(url)\(url1)/\(token)"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .getTeams,
             .getTeam,
             .getTeamEvents,
             .getEvents,
             .deleteTeam,
             .deleteEvent,
             .sendTokenToServer,
             .getHistoryNotifications:
            return []
        case let .enterTeam(_, name):
            return [.init(name: "name", value: name)]
        case let .addEvent(_, name, description, location, latitude, longitude):
            return [.init(name: "name", value: name),
                    .init(name: "description", value: description),
                    .init(name: "latidude", value: String(latitude)),
                    .init(name: "longitude", value: String(longitude)),
                    .init(name: "location", value: location)]
        case let .updateTeamName(_, _, name):
            return [.init(name: "new_name", value: name)]
        case let .setTeamEventScore(_, _, _, score):
            return [.init(name: "score", value: "\(score)")]
        }
    }

    private var httpMethod: String {
        switch self {
        case .getTeams,
             .getTeam,
             .getTeamEvents,
             .getEvents,
             .getHistoryNotifications:
            return HTTP.Method.get.rawValue
        case .enterTeam,
             .addEvent,
             .sendTokenToServer:
            return HTTP.Method.post.rawValue
        case .updateTeamName,
             .setTeamEventScore:
            return HTTP.Method.put.rawValue
        case .deleteTeam, .deleteEvent:
            return HTTP.Method.delete.rawValue
        }
    }

    private var httpBody: Data? {
        switch self {
        case let .sendTokenToServer(_, _, token):
            let jsonPost = try? JSONEncoder().encode(["token": token])
            return jsonPost
        default:
            return nil
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        default:
            setValue("*/*", forHTTPHeaderField: "Accept")
            setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
            setValue("keep-alive", forHTTPHeaderField: "Connection")
            setValue("YourApp/1.0", forHTTPHeaderField: "User-Agent")
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
