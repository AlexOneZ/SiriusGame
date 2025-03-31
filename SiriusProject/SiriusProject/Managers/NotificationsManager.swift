//
//  NotificationsManager.swift
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
    
    override init() {
        super.init()
    }
    
    func setup(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
        notificationCenter.delegate = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
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
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
}
