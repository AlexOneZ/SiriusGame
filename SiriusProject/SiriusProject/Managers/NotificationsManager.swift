//
//  NotificationsManager.swift
//  SiriusProject
//
//  Created by Maria Mayorova on 28.03.2025.
//

import Foundation
import UIKit
import UserNotifications

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    var app: SiriusProjectApp?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let stringifiedToken = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        // go to the screen with notifications
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}
