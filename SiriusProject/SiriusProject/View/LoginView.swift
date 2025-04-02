//
//  LoginView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    @AppStorage("isJudge") var isJudge: Bool = false
    @AppStorage("isLogin") var isLogin: Bool = false

    var body: some View {
        VStack {
            Text("enter")
                .font(.system(size: 65, weight: .semibold))
                .padding(.top, 60)

            Spacer()

            TextFieldView(title: "team title", text: $viewModel.text)

            Spacer()

            Button {
                isLogin = true
                isJudge = false
            } label: {
                SButton(title: "login")
            }
            Button {
                isLogin = true
                isJudge = true
            } label: {
                SButton(title: "login_as_judge")
            }
            .padding(.bottom, 70)
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging)))
}
