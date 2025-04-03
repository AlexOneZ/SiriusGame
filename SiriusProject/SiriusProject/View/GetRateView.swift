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
    @Binding var isHandReview: Bool

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            Text("Введите проверочный код")
                .font(.headline)
            Group {
                TextField("Оценка", text: $viewModel.score.value)
                    .validatedField(validatedField: viewModel.score, placeholder: "Оценка")
                SecureField("Пароль судьи", text: $viewModel.judgePasscode.value)
                    .validatedField(validatedField: viewModel.judgePasscode, placeholder: "Пароль судьи")
            }
            .keyboardType(.numberPad)

            Spacer()

            Button {
                guard let number = Int(viewModel.score.value) else { return }
                score = number
                isHandReview = true
                dismiss()
            } label: {
                Text("Оценить")
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
