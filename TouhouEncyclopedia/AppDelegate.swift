//
//  AppDelegate.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/06/26.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //その他に含まれる作品数
    let exceptionTitle:Int = 5;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if CheckUpdated(){
            //plistファイル更新
            let plistFileManager = PlistFileManager.plistFileManager
            plistFileManager.UpdatePlistFile()
            
            //SQLファイル更新
            let sqlFileManager = SqlFileManager.sqlFileManager
            sqlFileManager.UpdateSQLFile()
        }
        
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

    
    //アップロード後か確認
    func CheckUpdated() -> Bool
    {
        let loadedVersion:String
        
        //以前にロードしたバージョン確認
        let userDefaults = UserDefaults.standard
        if let tmpStr:String = userDefaults.string(forKey: "appVersionString"){
            loadedVersion = tmpStr
        } else {
            return false
        }
        
        //現在のバンドルのバージョン確認
        let infoDictionary = Bundle.main.infoDictionary!
        let bundleVersion:String = infoDictionary["CFBundleShortVersionString"]! as! String
        
        return !(loadedVersion == bundleVersion)
    }
}

