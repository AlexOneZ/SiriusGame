//
//  GetRateView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

struct GetRateView: View {
    @ObservedObject var viewModel = GetRateViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var score: Int?

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            Text("Enter score and passcode to rate")
                .font(.headline)
            Group {
                TextField("Score", text: $viewModel.score.value)
                    .validatedField(validatedField: viewModel.score, placeholder: "Score")
                    .onChange(of: viewModel.score.value) {
                        guard let number = Int(viewModel.score.value) else { return }
                        score = number
                    }
                SecureField("Judge password", text: $viewModel.judgePasscode.value)
                    .validatedField(validatedField: viewModel.judgePasscode, placeholder: "Judge password")
            }
            .keyboardType(.numberPad)

            Spacer()

            Button {
                dismiss()
            } label: {
                Text("Rate")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: 300)
                    .background(!viewModel.canSubmit ? Color(.systemGray4) : Color(.siriusBlue))
                    .cornerRadius(20)
            }
            .disabled(!viewModel.canSubmit)
            .padding()
        }
    }
}
