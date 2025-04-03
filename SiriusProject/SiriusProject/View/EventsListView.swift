//
//  EventsListView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct EventsListView: View {
    var appViewModel: AppViewModel
    private let log: (String) -> Void
    @ObservedObject var viewModel: EventsListViewModel
    @Binding var isNotificationViewShowing: Bool
    @State var isNeedUpdate: Bool = false

    init(
        appViewModel: AppViewModel,
        eventsListViewModel: EventsListViewModel,
        isNotificationViewShowing: Binding<Bool>,
        log: @escaping (String) -> Void = { _ in }
    ) {
        self.appViewModel = appViewModel
        viewModel = eventsListViewModel
        _isNotificationViewShowing = isNotificationViewShowing
        self.log = log
    }

    var body: some View {
        ZStack {
            if viewModel.events.isEmpty {
                Text("noevents")
                    .foregroundStyle(.placeholder)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.events, id: \.id) { event in
                            EventCard(appViewModel: appViewModel, event: event, isNeedUpdate: $isNeedUpdate)
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.fetchEvents()
        }
        .onAppear {
            print("Try get events on appear")
            viewModel.fetchEvents()
        }
        .onChange(of: isNeedUpdate) {
            print("New fetch events")
            viewModel.fetchEvents()
        }
        .overlay(alignment: .bottomTrailing) {
            NotificationsButton(
                action: { isNotificationViewShowing = true }
            )
            .padding(.trailing, 30)
            .padding(.bottom, 40)
        }
    }
}
