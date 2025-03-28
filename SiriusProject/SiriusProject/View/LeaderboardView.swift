//
//  LeaderboardView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 27.03.2025.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel: LeaderboardViewModel

    init(liderboardViewModel: LeaderboardViewModel) {
        viewModel = liderboardViewModel
    }

    var body: some View {
        VStack {
            Group {
                Text("Leaderboard")
                    .font(.title)
                HStack {
                    Text("teamPlace")
                    Spacer()
                    Text("team")
                    Spacer()
                    Text("score")
                }
            }
            .fontWeight(.bold)
            .padding()
            ScrollView {
                ForEach(Array(zip(viewModel.sortedTeams.indices, viewModel.sortedTeams)), id: \.0) { index, team in
                    LeaderboardTeamView(place: index + 1, circleColor: getPlaceColor(for: index + 1), teamTitle: team.name, score: team.score, currentTeam: team.id)
                    Divider()
                }
            }
        }
    }

    func getPlaceColor(for place: Int) -> Color {
        switch place {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return Color(.systemGray6)
        }
    }
}

// #Preview {
//    LeaderboardView(liderboardViewModel: LeaderboardViewModel(networkManager: ))
// }
