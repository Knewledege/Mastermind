//
//  AppDelegate.swift
//  mastermind
//
//  Created by takahashi kei on 2017/01/26.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fight_label:Double!
    var result:Int!
    var returntest:Int! = 0
    var session : MCSession!
    
    //全部の比較対象格納
    var mine_cell = NSMutableArray()
    var mine_hit_cell = NSMutableArray()
    var mine_blow_cell = NSMutableArray()
    var cpu_cell = NSMutableArray()
    var cpu_hit_cell = NSMutableArray()
    var cpu_blow_cell = NSMutableArray()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Initialize Google Mobile Ads SDK, application IDを設定
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4512223201861912~9267310587")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
