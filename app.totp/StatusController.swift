//
//  Untitled.swift
//  app.totp
//
//  Created by PropertyShare on 17/06/25.
//

import AppKit
import SwiftUI

class StatusBarController {
    let otpController = OTPController.instance
    private var statusItem: NSStatusItem

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "Authenticator")
        statusItem.menu = constructMenu()
        
        
        let delay = TimeInterval(secondsRemaining())
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.statusItem.menu = self.constructMenu()
            self.scheduleNextUpdate() // Use recursion to update again
        }
    }

    func scheduleNextUpdate() {
        let delay = TimeInterval(secondsRemaining())
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.statusItem.menu = self.constructMenu()
            self.scheduleNextUpdate()
        }
    }
    func secondsRemaining(interval: TimeInterval = 30) -> Int {
        let now = Date().timeIntervalSince1970
        return Int(interval - (now.truncatingRemainder(dividingBy: interval)))
    }
    
    
    func constructMenu() -> NSMenu {
        let menu = NSMenu()
        let accounts = otpController.accounts

        for (name, secret) in accounts {
            guard let code = otpController.generateTOTP(secret: secret) else { continue }
//            let remaining = secondsRemaining()
            let title = "\(name)"
            let item = NSMenuItem(title: title, action: #selector(copyToClipboard(_:)), keyEquivalent: "")
            item.representedObject = code
            item.target = self
            menu.addItem(item)
        }
        
        // Add Settings menu item
        let settingsItem = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        return menu
    }
    


    @objc func copyToClipboard(_ sender: NSMenuItem) {
        if let code = sender.representedObject as? String {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(code, forType: .string)
        }
    }

    @objc func quit() {
        NSApp.terminate(nil)
    }
    
    // Action for opening the settings window
    @objc func showSettings() {
        let settingsWindow = NSWindow(
            contentViewController: NSHostingController(rootView: SettingsView())
        )
        settingsWindow.setContentSize(NSSize(width: 800, height: 300))
        settingsWindow.styleMask = [.titled, .closable, .resizable]
        settingsWindow.title = "Settings"
        settingsWindow.makeKeyAndOrderFront(nil)
    }
}

