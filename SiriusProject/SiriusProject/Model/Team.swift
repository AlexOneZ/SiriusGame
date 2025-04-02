//
//  Team.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

struct Team: Codable {
    let id: Int
    var name: String
    var score: Int = 0
}

struct EnterTeamResponse: Codable {
    let ok: Bool
    let team_id: Int
}
