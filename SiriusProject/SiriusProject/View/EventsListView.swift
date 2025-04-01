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

    @AppStorage("isJudge") var isJudge: Bool = false
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State var isPresentedJudgeScreen: Bool = false
    @State var presentedEventForUser: Event? = nil
    
    init(
        eventsListViewModel: EventsListViewModel,
        isNotificationViewShowing: Binding<Bool>,
        log: @escaping (String) -> Void = { _ in}
    ) {
        viewModel = eventsListViewModel
        _isNotificationViewShowing = isNotificationViewShowing
        self.log = log
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.events, id: \.id) { event in
                    EventCard(show: $viewModel.showRateView, event: event)
                    // delete later
                        .onTapGesture {
                            if isJudge {
                                isPresentedJudgeScreen = true
                            }
                            else {
                                presentedEventForUser = event
                            }
                        }
                }
            }
        }
        .refreshable {
            viewModel.fetchEvents()
        }
        .sheet(isPresented: $viewModel.showRateView, content: { GetRateView() })
        .overlay(alignment: .bottomTrailing) {
            NotificationsButton(
                action: { isNotificationViewShowing = true }
            )
            .padding(.trailing, 30)
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $isPresentedJudgeScreen) {
            SendReviewToUserView(log: log)
        }
        .sheet(item: $presentedEventForUser) { event in
            GetReviewView(event: event, log: log)
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
