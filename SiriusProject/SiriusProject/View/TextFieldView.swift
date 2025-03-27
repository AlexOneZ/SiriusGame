//
//  TextFieldView.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

struct TextFieldView: View {
    var title: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .medium))
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.black.opacity(0.1))
                    }
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    @State var previewText = ""
    TextFieldView(title: "team title", text: $previewText)
}
