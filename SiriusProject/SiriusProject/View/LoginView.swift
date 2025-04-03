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
    @AppStorage("teamID") var teamID: Int = 0

    @State var isJudgeLogin: Bool = false
    @State var inputJudgePin: String = ""
    let judgeSecretKey = "1234"

    var body: some View {
        VStack {
            Text("enter")
                .font(.system(size: 65, weight: .semibold))
                .padding(.top, 60)

            Spacer()

            TextFieldView(title: "teamtitle", text: $viewModel.teamName)

            Spacer()

            Button {
                viewModel.newTeamRegister()
            } label: {
                SButton(title: "login")
            }
            Button {
                isJudgeLogin = true
            } label: {
                SButton(title: "login_as_judge")
            }
            .alert("Введите пароль судьи", isPresented: $isJudgeLogin, actions: {
                SecureField("Пароль", text: $inputJudgePin)
                Button("Проверить", role: .cancel, action: {
                    if judgeSecretKey == inputJudgePin {
                        isLogin = true
                        isJudge = true
                    }
                })
                Button(
                    "Отмена",
                    role: .destructive,
                    action: {}
                )
            })
            .padding(.bottom, 70)
        }
        .padding()
        .onAppear {
            viewModel.logging("teamId on lView \(teamID)")
        }
        .onChange(of: teamID) {
            viewModel.logging("teamID changed")
            isLogin = true
            isJudge = false
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging), logging: { _ in }))
}
