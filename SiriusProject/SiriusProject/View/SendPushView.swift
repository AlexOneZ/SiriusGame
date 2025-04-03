//
//  SendPushView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import SwiftUI

struct SendPushView: View {
    @ObservedObject var viewModel: SendPushViewModel

    init(viewModel: SendPushViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("sendpush")
                .font(.title)
                .bold()
            Spacer()

            TextFieldView(title: "Текст уведомления", text: $viewModel.pushText)

            Button {
                viewModel.pushText
            } label: {
                Text("sendpushbutton")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.canSubmit ? Color(.siriusBlue) : Color(.systemGray5))
                    .cornerRadius(20)
                    .padding()
            }
            .disabled(viewModel.canSubmit)

            Spacer()
        }
    }
}
