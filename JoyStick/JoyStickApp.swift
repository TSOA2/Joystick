//
//  JoyStickApp.swift
//  JoyStick
//
//  Created by TSOA2 on 1/20/24.
//

import SwiftUI

// Thanks Apple for making screen locking so painful 😍
// Functional programming is called "functional" for a reason: it works.
// Object oriented programming is called "OOP" as in "oops"

@main
struct JoyStickApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientation_lock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientation_lock
    }
}
