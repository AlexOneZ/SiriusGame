//
//  SettingsView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    @State var isPresented: Bool = false
    @State var changedName: String = ""

    @AppStorage("isJudge") var isJudge: Bool = false
    @AppStorage("isLogin") var isLogin: Bool = false

    init(settingsViewModel: SettingsViewModel) {
        viewModel = settingsViewModel
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
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: printLogging))
}
