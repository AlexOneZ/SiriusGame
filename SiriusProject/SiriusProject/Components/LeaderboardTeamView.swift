//
//  LeaderboardTeamView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 27.03.2025.
//

import SwiftUI

struct LeaderboardTeamView: View {
    var place: Int
    var circleColor: Color
    var teamTitle: String
    var score: Int
    var currentTeam: Int
    var body: some View {
        HStack {
            Text("\(place)")
                .padding()
                .background {
                    Circle()
                        .foregroundStyle(circleColor)
                }

            Spacer()

            Text(teamTitle)

            Spacer()

            Text("\(score)")
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(currentTeam == 0 ? Color(.systemGray4) : Color(.systemBackground))
    }
}

#Preview {
    LeaderboardTeamView(place: 1, circleColor: Color(.green), teamTitle: "HSE FCS", score: 100, currentTeam: 0)
}
