//
//  ValidatedFieldModifier.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import Foundation
import SwiftUI

struct ValidatedFieldModifier: ViewModifier {
    @ObservedObject var validatedField: ValidatedField
    let placeholder: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            content
                .padding()
                .frame(maxWidth: 300)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .overlay(
                    validatedField.isEdited && validatedField.error != nil ? AnyView(RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 1)) :
                        AnyView(EmptyView())
                )

            if validatedField.isEdited {
                Text(validatedField.error ?? " ")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}

extension View {
    func validatedField(validatedField: ValidatedField, placeholder: String) -> some View {
        modifier(ValidatedFieldModifier(validatedField: validatedField, placeholder: placeholder))
    }
}
