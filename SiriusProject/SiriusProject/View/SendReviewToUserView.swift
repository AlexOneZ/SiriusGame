//
//  SendReviewToUserView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 01.04.2025.
//

import SwiftUI

struct SendReviewToUserView: View {
    var event: Event
    private let log: (String) -> Void
    @State var score = 0.0
    @State var isEditingChanged: Bool = false
    @State private var showConfirmation: Bool = false
    
    init(event: Event = Event(id: 1, title: "Title", description: "Description", state: .done, score: 1),
             log: @escaping (String) -> Void = { _ in }) {
            self.event = event
            self.log = log
            self._score = State(initialValue: Double(event.score))
        }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Rate the event")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 24)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 6)
                    .foregroundStyle(.gray.opacity(0.2))
                
                Circle()
                    .trim(from: 0, to: score / 10)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .foregroundStyle(score < 5 ? .red : score < 8 ? .orange : .green)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: score)
                
                Text(String(format: "%0.f", score))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(score < 5 ? .red : score < 8 ? .orange : .green)
            }
            .frame(width: 120, height: 120)
            .padding(.vertical, 16)
            
            VStack(spacing: 8) {
                Slider(
                    value: $score,
                    in: 0...10,
                    step: 1,
                    onEditingChanged: { editing in
                        withAnimation {
                            isEditingChanged = editing
                        }
                    })
                .tint(score < 5 ? .red : score < 8 ? .orange : .green)
                .padding(.horizontal, 32)
                
                HStack {
                    Text("0")
                    Spacer()
                    Text("10")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            }
            
            Spacer()
            
            
            
            if let urlSceme = getSendInfoURL(event: event) {
                ShareLink(
                       item: urlSceme,
                       preview: SharePreview("send_url_info")
                   ) {
                       HStack {
                           Image(systemName: "square.and.arrow.up")
                           Text("Share Rating")
                       }
                       .font(.headline)
                       .foregroundStyle(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(score < 1 ? .gray : .blue)
                       .cornerRadius(12)
                       .padding(.horizontal, 32)
                       .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                   }
                   .disabled(score < 1)
                   //.buttonStyle(ScaleButtonStyle())
                   .padding()
            } 
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private func getSendInfoURL(event: Event) -> URL? {
        let logMessage = "String to url: siriusgameurl://*\(event.id)*\(Int(score))"
        log(logMessage)

        return URL(string: "siriusgameurl://*\(event.id)*\(Int(score))")
    }
}

#Preview {
    SendReviewToUserView()
}
