//
//  EventAttributes.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 04.04.2025.
//

import ActivityKit
import Foundation

struct EventAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var eventName: String
        var status: String
        var nextEventName: String
        var nextEventSatus: String
        var score: Int

        init(currentEvent: Event?, nextEvent: Event?, score: Int) {
            if let currentEvent = currentEvent {
                eventName = currentEvent.title
                status = currentEvent.state.rawValue
            } else {
                eventName = "finish"
                status = "finish"
            }

            if let nextEvent = nextEvent {
                nextEventName = nextEvent.title
                nextEventSatus = nextEvent.state.rawValue
            } else {
                nextEventName = "finish"
                nextEventSatus = "finish"
            }

            self.score = score
        }
    }
}
