//
//  SButton.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

struct SButton: View {
    
    var title: LocalizedStringKey
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("SiriusColor"))
            .stroke(Color.black, lineWidth: 1)
            .frame(width: 300, height: 50)
            .overlay(
                Text(title)
                    .foregroundColor(.black)
            )
    }
}

#Preview {
    SButton(title: "login")
}
