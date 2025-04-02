//
//  LoginView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("enter")
                .font(.system(size: 65, weight: .semibold))
                .padding(.top, 60)

            Spacer()

            TextFieldView(title: "team title", text: $viewModel.text)

            Spacer()

            Button {
                // action
            } label: {
                SButton(title: "login")
            }
            .padding(.bottom, 70)
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging)))
}
