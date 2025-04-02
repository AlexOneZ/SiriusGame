//
//  PointsView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

struct PointsView: View {
    @ObservedObject var viewModel: PointsViewModel

    var body: some View {
        VStack {
            header
            Spacer()

            TextFieldView(title: "points", text: $viewModel.points)
                .padding()

            TextFieldView(title: "pin", text: $viewModel.pin)
                .padding()

            Spacer()

            Button {
                // action
            } label: {
                SButton(title: "credit")
            }
            .padding(.bottom, 70)
        }
    }

    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("score")
                    .font(.system(size: 50, weight: .semibold))

                Text("football")
                    .font(.system(size: 20))
            }
            .padding(.leading, 50)
            .padding(.top, 50)
            Spacer()
        }
    }
}

#Preview {
    PointsView(viewModel: PointsViewModel(networkManager: FakeNetworkManager(logging: printLogging)))
}
