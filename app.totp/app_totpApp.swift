//
//  app_totpApp.swift
//  app.totp
//
//  Created by PropertyShare on 17/06/25.
//

import SwiftUI

@main
struct app_totpApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {} // Or `EmptyView()` if you want nothing
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
    }
}
