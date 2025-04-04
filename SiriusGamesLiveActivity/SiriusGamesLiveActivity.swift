//
//  SiriusGamesLiveActivity.swift
//  SiriusGamesLiveActivity
//
//  Created by Илья Лебедев on 04.04.2025.
//
import ActivityKit
import SwiftUI
import WidgetKit

@main
struct SportsActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EventAttributes.self) { context in
            if let eventState = EventState(rawValue: context.state.status), let nextEventSutus = EventState(rawValue: context.state.nextEventSatus) {
                LockScreenActivityView(
                    eventName: context.state.eventName,
                    currentEventState: eventState,
                    status: context.state.status,
                    nextEventName: context.state.nextEventName,
                    nextEventStatus: nextEventSutus,
                    score: context.state.score
                )}
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    if let eventState = EventState(rawValue: context.state.status) {
                        HStack {
                            Circle()
                                .foregroundStyle(eventState.getColor())
                                .frame(width: 10)
                            Text("\(NSLocalizedString(context.state.status, comment: "status"))")
                        }
                    }
                    Text("\(context.state.eventName)")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(NSLocalizedString("score", comment: "score") + ": \(context.state.score)")
                        .bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    if let eventState = EventState(rawValue: context.state.nextEventSatus) {
                        HStack {
                            Circle()
                                .foregroundStyle(eventState.getColor())
                                .frame(width: 10)
                            Text("\(context.state.nextEventSatus)")
                        }
                    }
                    Text("\(context.state.nextEventName)")
                }
            } compactLeading: {
                Text("\(context.state.eventName)")
            } compactTrailing: {
                Text("\(context.state.score)")
                    .bold()
            } minimal: {
                Text("")
            }
        }
    }
}
