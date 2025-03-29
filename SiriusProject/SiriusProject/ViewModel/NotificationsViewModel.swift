//
//  NotificationsViewModel.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 29.03.2025.
//

import SwiftUI

final class NotificationsViewModel: ObservableObject {
    let networkManager: NetworkManagerProtocol
    @Published var notifications: [Notification] = [
        Notification(
            title: "Регистрация команды",
            body: "Ваша команда успешно зарегистрирована! Можете приступать к игре!"
        ),
        Notification(
            title: "Соревнование началось!",
            body: "Уважаемые участники! Соревнование по футболу уже началось!"
        ),
        Notification(
            title: "Соревнование завершено!",
            body: "Уважаемые участники! Соревнование по футболу завершено! Вы набрали 7/10 баллов!"
        ),
        Notification(
            title: "Соревнование началось!",
            body: "Уважаемые участники! Соревнование по хоккею уже началось!"
        ),
        Notification(
            title: "Соревнование завершено!",
            body: "Уважаемые участники! Соревнование по хоккею завершено! Вы набрали 10/10 баллов!"
        ),
        Notification(
            title: "Соревнование началось!",
            body: "Уважаемые участники! Соревнование по гольфу уже началось!"
        ),
        Notification(
            title: "Соревнование завершено!",
            body: "Уважаемые участники! Соревнование по гольфу завершено! Вы набрали 3/10 баллов!"
        )
    ]

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}
