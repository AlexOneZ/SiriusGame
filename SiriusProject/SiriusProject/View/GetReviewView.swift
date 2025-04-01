//
//  GetReviewView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 01.04.2025.
//

import SwiftUI

struct GetReviewView: View {
    let event: Event?
    @State var isPresented: Bool = false
    
    private let log: (String) -> Void //= { _ in }

    init(event: Event = Event(id: 1, title: "Title",description: "description", state: .done, score: 10),
         log: @escaping (String) -> Void = { message in
        #if DEBUG
            print(message)
        #endif
    }) {
        self.event = event
        self.log = log
    }
    
    var body: some View {
        VStack {
            Text("Получить оценку")
                .font(.title)
                .padding()
            if event != nil {
                Text(event?.title ?? "")
                Text(event?.description ?? "")
            }
            Text("Попросите судью выставить вам оценку за эту дисциплину, проверьте, что AirDrop включен")
        }
        .onOpenURL { url in
            guard let idAndScore = url.recieveDeeplinkURL(log: log)
            else { return }
            
            isPresented = true
            
            let logMessage = """
                \(idAndScore[0]),
                \(idAndScore[1])
            """
            log(logMessage)
        }
        .alert("Оценка получена", isPresented: $isPresented, actions: {
            Button("Хорошо", role: .cancel, action: {})
        }, message: {
            Text("Оценка за дисциплину \(String(describing: event?.title)) получена!")
        })
        
    }
}

private extension URL {
    func recieveDeeplinkURL(log: @escaping (String) -> Void = { _ in }) -> [Int]? {
        let infoFromURL = absoluteString
        let parsedInfo = infoFromURL.split(separator: "*")

        guard let id = Int(parsedInfo[1]) else {
            log("ID not converted!")
            return nil
        }
        guard let score = Int(parsedInfo[2]) else {
            log("Score not converted")
            return nil
        }

        return [id, score]
    }
}

#Preview {
    //GetReviewView(event: nil)
}
