//
//  PointsViewModel.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 27.03.2025.
//

import SwiftUI

final class PointsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    @Published var points = ""
    @Published var pin = ""
}
