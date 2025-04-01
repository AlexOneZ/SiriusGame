//
//  EventsListViewModel.swift
//  SiriusProject
//
//  Created by Андрей Степанов on 26.03.2025.
//

import SwiftUI

final class EventsListViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var showRateView: Bool = false

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getEvents() -> [Event] {
        networkManager.getAllEvents()
    }
}
