//
//  EventInfoBlockViewComponent.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

struct EventInfoBlockViewComponent: View {
    let title: String
    let description: String
    @State var height: CGFloat? = nil
    @Binding var hide: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title):")
                .font(.subheadline)
                .fontWeight(.bold)

            Text(description)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxHeight: height)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.siriusBlue2, .siriusBlue2]), startPoint: .topLeading, endPoint: .topLeading)
                )
        }
        .transition(.slide)
    }
}

#Preview {
    EventInfoBlockViewComponent(
        title: "Rules",
        description: "No rules. Fight.",
        hide: .constant(false)
    )
}
