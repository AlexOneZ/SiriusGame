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
            Text("Leaderboard")
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text("teamPlace")
                    .fontWeight(.bold)
                Spacer()
                Text("team")
                    .fontWeight(.bold)
                Spacer()
                Text("score")
                    .fontWeight(.bold)
            }
            .padding()
            ScrollView {
                ForEach(Array(zip(viewModel.sortedTeams.indices, viewModel.sortedTeams)), id: \.0) { index, team in
                    LeaderboardTeamView(place: index + 1, circleColor: viewModel.getPlaceColor(for: index + 1), teamTitle: team.name, score: team.score, currentTeam: team.id)
                    Divider()
                }
            }
        }
    }
}

// #Preview {
//    LeaderboardView(liderboardViewModel: LeaderboardViewModel(networkManager: ))
// }
