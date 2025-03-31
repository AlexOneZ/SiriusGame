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

    override init() {
        super.init()
    }

    func setup(
        notificationCenter: UNUserNotificationCenter,
        runner: @escaping MainThreadRunner
    ) {
        self.notificationCenter = notificationCenter
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
        let stringifiedToken = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        // send token to server
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {}

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}
