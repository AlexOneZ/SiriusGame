//
//  SendReviewToUserView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 01.04.2025.
//

import SwiftUI

struct SendReviewToUserView: View {
    let event = Event(
        id: 1,
        title: "Title",
        description: "Description",
        state: .done,
        score: 1
    )
    private let log: (String) -> Void
    @State var score = 0.0
    @State var isEditingChanged: Bool = false
    
    init(log: @escaping (String) -> Void = { _ in }) {
        self.log = log
    }
    
    var body: some View {
        Text("Send Review")
            .font(.title)
        Slider(value: $score, in: 0...10, step: 1, onEditingChanged: { editing in
            isEditingChanged = editing
        })
        .padding(.leading, 40)
        .padding(.trailing, 40)
        Text("Score Value: \(Int(score))")
            .font(.title2)
        
        if let urlSceme = getSendInfoURL(event: event) {
            ShareLink(
                item: urlSceme,
                preview:
                SharePreview("send_url_info")
            ) {
                Label("", systemImage: "square.and.arrow.up")
            }
            .padding()
        }
    }
    
    private func getSendInfoURL(event: Event) -> URL? {
        let logMessage = "String to url: siriusgameurl://*\(event.id)*\(event.score)"
        log(logMessage)

        return URL(string: "siriusgameurl://*\(event.id)*\(event.score)")
    }
}

#Preview {
//    SendReviewToUserView(log: { message in
//                #if DEBUG
//                        print(message)
//                #endif
//    }, score: 1)
    //SendReviewToUserView(
}
