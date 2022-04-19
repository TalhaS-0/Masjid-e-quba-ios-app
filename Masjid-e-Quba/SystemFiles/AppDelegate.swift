//
//  AppDelegate.swift
//  Masjid-e-Quba
//
//  Created by Ali Waseem on 1/25/22.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FirebaseCore
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: Navbar design
        let navigationBarAppearace = UINavigationBar.appearance()
//        navigationBarAppearace.barTintColor = UIColor.systemBlue
//        navigationBarAppearace.backgroundColor = UIColor.systemBlue
        navigationBarAppearace.tintColor = UIColor.black
        if #available(iOS 13.0, *) {
                    navigationBarAppearace.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
          }
//        navigationBarAppearace.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationBarAppearace.titleTextAttributes = [.foregroundColor:UIColor.white]
        //MARK: Firebase
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        //MARK: OneSignal
        // Remove this method to stop OneSignal Debugging
          OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
          
          // OneSignal initialization
          OneSignal.initWithLaunchOptions(launchOptions)
          OneSignal.setAppId("2a720ed3-5b42-49c0-b1d6-2e2aea4fced6")
          
          // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
          OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
          })
          
          // Set your customer userId
//           OneSignal.setExternalUserId("userId")
          
          
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

