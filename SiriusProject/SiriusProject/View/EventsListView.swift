//
//  EventsListView.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel: EventsListViewModel

    init(eventsListViewModel: EventsListViewModel) {
        viewModel = eventsListViewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.getEvents(), id: \.id) { event in
                    EventCard(event: event)
                }
            }
        }
    }
}

#Preview {
    EventsListView(eventsListViewModel: EventsListViewModel(networkManager: FakeNetworkManager()))
        .environment(\.locale, .init(identifier: "ru"))
}
