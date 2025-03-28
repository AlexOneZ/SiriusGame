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

    init(settingsViewModel: SettingsViewModel) {
        viewModel = settingsViewModel
    }

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.teamName)
                .font(.title)

            Spacer()

            Button("changename") {
                isPresented = true
            }
            .alert("teamname", isPresented: $isPresented, actions: {
                TextField("newteamname", text: $changedName)

                Button("accept", action: {
                    print("\(changedName)")
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
    SettingsView(settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager()))
}
