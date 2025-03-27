//
//  SettingsView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    init(settingsViewModel: SettingsViewModel) {
        viewModel = settingsViewModel
    }

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.teamName)
                .font(.title)

            Spacer()

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
