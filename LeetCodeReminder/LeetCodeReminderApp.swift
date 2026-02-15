//
//  LeetCodeReminderApp.swift
//  LeetCodeReminder
//
//  Created on Feb 15, 2026
//

import SwiftUI

@main
struct LeetCodeReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
    }
}
