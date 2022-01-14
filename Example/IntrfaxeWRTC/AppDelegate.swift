//
//  AppDelegate.swift
//  IntrfaxeWRTC
//
//  Created by 11611707 on 11/17/2021.
//  Copyright (c) 2021 11611707. All rights reserved.
//

import UIKit
import IntrfaxeWRTC

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IntrfaxeWRTC.sharedInstance.accessKey = ""
        IntrfaxeWRTC.sharedInstance.apiURL = "https://projects.codelabs.inc/webrtc/api/Rooms/CreateRoom"
        
        return true
    }

    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        print("Continue User Activity called: ")
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            let url = userActivity.webpageURL!
//            print(url.absoluteString)
//            //handle url and open whatever page you want to open.
//        }
//        return true
//    }
    
    
    
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

        
        print("****Function: \(#function), line: \(#line)****\n-- ")

            guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let url = userActivity.webpageURL, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                    return false
                }
        print("url \(url)")
        print("components.path \(components.path)")
        
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        let param1 = queryItems?.filter({$0.name == "room"}).first
        print(param1?.value ?? "")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FirstViewController") as? FirstViewController
        
        
        if (param1?.value != nil )
        
        {
            let decodedData = Data(base64Encoded: param1?.value ?? "")!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            
            print(decodedString)
            
            let strArray = decodedString.components(separatedBy: "_")
            print("roomID \(String(describing: strArray.last))")
            print("roomName \(String(describing: strArray.first))")

            let roomID = strArray.last ?? ""
            let roomName = strArray.first ?? ""
            
            if (!roomID.isEmpty){
                
                
                
                vc?.roomID = roomID
                vc?.roomName = roomName
                
                
                
                
            }
            
            
        }
        let navigationController = UINavigationController(rootViewController: vc!)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
        
        

            //FOR A URL "https://yourwebsite.com/testing/24
            //this will print the ID 24
            
//            if (components.path.contains("testing")) {
//                if let theid = Int(url.lastPathComponent) {
//                    print("test id from deep link \(theid)")
//                }
//            }
            
            
            return false
    }

 

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

