//
//  Endpoint.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 29.03.2025.
//

import Foundation

enum Endpoint {
    case getTeams(url: String = "/teams")
    case enterTeam(url: String = "/teams", name: String)
    case getTeam(url: String = "/teams", teamId: Int)
    case updateTeamName(url: String = "/teams", teamId: Int, name: String)
    case deleteTeam(url: String = "/teams", teamId: Int)
    case getTeamEvents(url: String = "/teams", teamId: Int, url1: String = "/events")
    case setTeamEventScore(url: String = "/teams", teamId: Int, url1: String = "/events", score: Int)

    case getEvents(url: String = "/events")
    case addEvent(url: String = "/events", name: String, description: String?)
    case deleteEvent(url: String = "/events", eventId: Int)

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
            return "\(url)/\(teamId)/\(url1)"
        case let .setTeamEventScore(url, teamId, url1, _):
            return "\(url)/\(teamId)/\(url1)"
        case let .getEvents(url):
            return url
        case let .addEvent(url, _, _):
            return url
        case let .deleteEvent(url, eventId):
            return "\(url)/\(eventId)"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .getTeams,
             .getTeam,
             .getTeamEvents,
             .getEvents,
             .deleteTeam,
             .deleteEvent:
            return []
        case let .enterTeam(_, name):
            return [.init(name: "name", value: name)]
        case let .addEvent(_, name, description):
            return [.init(name: "name", value: name),
                    .init(name: "description", value: description)]
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
             .getEvents:
            return HTTP.Method.get.rawValue
        case .enterTeam,
             .addEvent:
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
        }
    }
}
