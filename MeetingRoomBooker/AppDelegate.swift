//
//  AppDelegate.swift
//  MeetingRoomBooker
//
//  Created by Deeksha Shenoy on 07/09/17.

import UIKit
import Firebase

//let isLoginPageIsThereInNavigationStack: String = "isLoginPageIsThereInNavigationStack"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        FirebaseApp.configure()
        
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
       
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var navigationController: UINavigationController?
        
        if userEmail == nil {
            UserDefaults.standard.set(true, forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
            navigationController = UINavigationController(rootViewController: loginVC)
        } else {
            if userEmail ==  "admin@gmail.com"{
                UserDefaults.standard.set(false, forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
                let adminPageTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: AdminPageTableVC.self)) as! AdminPageTableVC
                navigationController = UINavigationController(rootViewController: adminPageTableVC)
            } else {
                UserDefaults.standard.set(false, forKey: UserDefaultKey.isLoginPageIsThereInNavigationStack)
                let roomsTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: RoomsTableVC.self)) as! RoomsTableVC
                navigationController = UINavigationController(rootViewController: roomsTableVC)
            }
        }
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
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

