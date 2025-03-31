//
//  SettingsView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    private let log: (String) -> Void

    @State var isPresented: Bool = false
    @State var changedName: String = ""

    let event = Event(
        id: 1,
        title: "Title",
        description: "Description",
        state: .done,
        score: 1
    )

    init(settingsViewModel: SettingsViewModel, log: @escaping (String) -> Void = { _ in }) {
        viewModel = settingsViewModel
        self.log = log
    }

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.teamName)
                .font(.title)

            Spacer()

            if let urlSceme = getSendInfoURL(event: event) {
                ShareLink(
                    item: urlSceme,
                    preview:
                    SharePreview("send_url_info")
                ) {
                    Label("", systemImage: "square.and.arrow.up")
                }
                .padding()
            }

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

    private func getSendInfoURL(event: Event) -> URL? {
        let logMessage = "String to url: siriusgameurl://*\(event.id)*\(event.title)*\(event.description)*\(event.state)*\(event.score)"
        log(logMessage)
        
        return URL(string: "siriusgameurl://*\(event.id)*\(event.title)*\(event.description)*\(event.state)*\(event.score)")
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel(networkManager: FakeNetworkManager()))
}
