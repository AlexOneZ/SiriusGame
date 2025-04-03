//
//  LocationDetailsView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 02.04.2025.
//

import MapKit
import SwiftUI

struct LoactionDetails: View {
    let event: Event
    @Binding var getRoute: Bool
    @Binding var selectemMapItem: Int?
    @Binding var show: Bool
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(event.title)
                        .fontWeight(.semibold)
                        .font(.title2)
                    Text("where") + Text(event.address)
                        .font(.callout)
                }
                Spacer()
                HStack {
                    Circle()
                        .foregroundStyle(event.state.getColor())
                        .frame(width: 10)
                    if let description = event.state.getDescription() {
                        Text(description)
                    } else {
                        Text("ochkov") + Text("\(event.score)")
                    }
                }

                Spacer()

                Button {
                    selectemMapItem = nil
                }
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.vertical)

            Button {
                getRoute = true
                show = false
            } label: {
                Text("setroute")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.siriusBlue))
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}
