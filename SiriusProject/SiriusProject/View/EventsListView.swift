//
//  EventsListView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel
    @Binding var isNotificationViewShowing: Bool

    init(
        eventsListViewModel: EventsListViewModel,
        isNotificationViewShowing: Binding<Bool>
    ) {
        viewModel = eventsListViewModel
        _isNotificationViewShowing = isNotificationViewShowing
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.getEvents(), id: \.id) { event in
                    EventCard(show: $viewModel.showRateView, event: event)
                }
            }
        }
        .sheet(isPresented: $viewModel.showRateView, content: { GetRateView() })
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
        eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager()),
        isNotificationViewShowing: .constant(false)
    )
    .environment(\.locale, .init(identifier: "ru"))
}
