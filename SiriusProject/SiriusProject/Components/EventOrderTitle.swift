//
//  EventOrderTitle.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 01.04.2025.
//

import SwiftUI

struct EventOrderTitle: View {
    let orderNumber: Int
    let title: String
    var body: some View {
        HStack {
            Text("\(orderNumber)")
                .padding()
                .background {
                    Circle()
                        .foregroundColor(Color("SiriusBlue2"))
                }
            Text(title)
        }
    }
}
