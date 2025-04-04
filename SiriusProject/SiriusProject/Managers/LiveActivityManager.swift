//
//  LiveActivityManager.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 04.04.2025.
//

import ActivityKit
import Foundation

class LiveActivityManager {
    private var activity: Activity<EventAttributes>?

    func startActivity(currentEvent: Event?, nextEvent: Event?, score: Int) {
        let attributes = EventAttributes()
        let initialState = EventAttributes.ContentState(currentEvent: currentEvent, nextEvent: nextEvent, score: score)

        do {
            activity = try Activity<EventAttributes>.request(
                attributes: attributes,
                contentState: initialState,
                pushType: nil
            )
            print("Live Activity запущена!")
        } catch {
            print("Ошибка запуска Live Activity: \(error.localizedDescription)")
        }
    }

    func updateActivity(currentEvent: Event?, nextEvent: Event?, score: Int) {
        Task {
            let newState = EventAttributes.ContentState(currentEvent: currentEvent, nextEvent: nextEvent, score: score)
            await activity?.update(using: newState)
        }
    }

    func endActivity() {
        Task {
            await activity?.end(dismissalPolicy: .immediate)
            activity = nil
        }
    }
}
