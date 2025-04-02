//
//  EventsListView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct EventsListView: View {
    private let log: (String) -> Void
    @ObservedObject var viewModel: EventsListViewModel
    @Binding var isNotificationViewShowing: Bool

    init(
        eventsListViewModel: EventsListViewModel,
        isNotificationViewShowing: Binding<Bool>,
        log: @escaping (String) -> Void = { _ in }
    ) {
        viewModel = eventsListViewModel
        _isNotificationViewShowing = isNotificationViewShowing
        self.log = log
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.events, id: \.id) { event in
                    EventCard(event: event)
                }
            }
        }
        .refreshable {
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

#Preview {
    EventsListView(
        eventsListViewModel: EventsListViewModel(
            networkManager: FakeNetworkManager(logging: printLogging),
            logging: printLogging
        ),
        isNotificationViewShowing: .constant(false)
    )
}
