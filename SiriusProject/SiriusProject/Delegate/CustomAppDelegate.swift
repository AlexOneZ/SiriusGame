//
//  CustomAppDelegate.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import Foundation
import UIKit
import UserNotifications

class CustomAppDelegate: NSObject, UIApplicationDelegate {
    var app: SiriusProjectApp?
    var notificationCenter: UNUserNotificationCenter!
    var runner: MainThreadRunner!
    var notificationsManager: NotificationsManager?
    var networkManager: NetworkManager?

    override init() {
        super.init()
    }

    func setup(
        notificationCenter: UNUserNotificationCenter,
        runner: @escaping MainThreadRunner,
        notificationsManager: NotificationsManager,
        networkManager: NetworkManager
    ) {
        self.notificationCenter = notificationCenter
        self.notificationsManager = notificationsManager
        self.networkManager = networkManager
        notificationCenter.delegate = self
        self.runner = runner
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            guard let self = self else { return }
            if granted {
                runner { [application] in
                    application.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let stringifiedToken = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        networkManager?.sendTokenToServer(token: stringifiedToken) { _ in }
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        if let destination = userInfo["destination"] as? String,
           destination == "notification"
        {
            runner { [weak self] in
                guard let self = self else { return }
                notificationsManager?.isNotificationViewShowing = true
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}
