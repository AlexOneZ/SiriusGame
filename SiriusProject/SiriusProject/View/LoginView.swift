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
    @AppStorage("teamID") var teamID: Int = -1
    
    @State var isJudgeLogin: Bool = false
    @State var inputJudgePin: String = ""
    let judgeSecretKey = "1234"

    var body: some View {
        VStack {
            Text("enter")
                .font(.system(size: 65, weight: .semibold))
                .padding(.top, 60)

            Spacer()

            TextFieldView(title: "team title", text: $viewModel.teamName)
            
            if teamID >= 0 {
                Text("Id defined")
            }

            Spacer()

            Button {
                isLogin = true
                isJudge = false
                viewModel.newTeamRegister()
            } label: {
                SButton(title: "login")
            }
            Button {
                isJudgeLogin = true
            } label: {
                SButton(title: "login_as_judge")
            }
            .alert("Eneter judge pin", isPresented: $isJudgeLogin, actions: {
                
                TextField("Input", text: $inputJudgePin)
                Button("Check?", role: .cancel ,action: {
                    if judgeSecretKey == inputJudgePin {
                        isLogin = true
                        isJudge = true
                    }
                })
                Button("Dismiss", role: .destructive, action: {}
                )
                
            }, message:{
                Text("Input pin:")
            })
            .padding(.bottom, 70)
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(networkManager: FakeNetworkManager(logging: printLogging)))
}
