//
//  MessagingApp.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user: UserModel = UserModel(id: nil, username: nil, first: nil, last: nil)

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
