//
//  CreateEventViewModel.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import Foundation
import MapKit

class CreateEventViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var adress: String = ""
    @Published var rules: String = ""
    @Published var submit: Bool = false
    @Published var location: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)

    let networkManager: NetworkManagerProtocol
    let logging: Logging

    init(networkManager: NetworkManagerProtocol, logging: @escaping Logging) {
        self.networkManager = networkManager
        self.logging = logging
    }

    var canSubmit: Bool {
        return !title.isEmpty && !description.isEmpty && !adress.isEmpty && !rules.isEmpty && location.latitude != 0 && location.longitude != 0
    }

    func addEvent() {
        networkManager.addEvent(name: title, description: description, location: adress, latidude: location.latitude, longitude: location.longitude) { [weak self] id in
            onMainThread {
                self?.logging("try setup id \(id)")
            }
        }
    }
}
