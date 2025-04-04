//
//  SettingsView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    let logging: Logging

    @State var isPresented: Bool = false
    @State var changedName: String = ""

    @AppStorage("isJudge") var isJudge: Bool = false
    @AppStorage("isLogin") var isLogin: Bool = false

    init(settingsViewModel: SettingsViewModel, logging: @escaping Logging) {
        viewModel = settingsViewModel
        self.logging = logging
    }

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.teamName)
                .font(.title)
                .padding()

            Text("role") +
                Text(": ") +
                Text(isJudge ? LocalizedStringKey("judge") : LocalizedStringKey("participant"))

            Button {
                viewModel.deleteAllTeams()
            } label: {
                Text("deleteallteams")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color(.red))
                    .cornerRadius(20)
            }
            .alert("askdeleteallteams", isPresented: $viewModel.showAlert, actions: {
                Button("delete", role: .destructive) {
                    viewModel.deleteTeams = true
                }
                Button("cancel", role: .cancel) {}
            })

            .alert("teamsdeleted", isPresented: $viewModel.teamsDeleted, actions: {
                Button("Ok", role: .cancel) {}
            })

            Spacer()

            Button("changename") {
                isPresented = true
            }
            .alert("teamname", isPresented: $isPresented, actions: {
                TextField("newteamname", text: $changedName)

                Button("accept", action: {
                    viewModel.changeName(newName: changedName)
                })
                Button("cancel", role: .cancel, action: {})
            }, message: {
                Text("inputnewname")
            })
            .padding(.bottom)
            Button("logout") {
                viewModel.logOutAction()
            }
            .padding(.bottom)
        }
        .onAppear {
            print("try fetch")
            viewModel.fetchTeamName()
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging), logging: { _ in })
}
