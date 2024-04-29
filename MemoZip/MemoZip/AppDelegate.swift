//
//  AppDelegate.swift
//  MemoZip
//
//  Created by 박세라 on 3/9/24.
//

import UIKit
import MyLibrary
import ReactorKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?        // window 프로퍼티 추가
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        
        let reminderListViewController = UINavigationController(rootViewController: ReminderListViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let homeViewController = UINavigationController(rootViewController:  HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBarController.setViewControllers([homeViewController, reminderListViewController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "house.fill")
            items[0].image = UIImage(systemName: "house")
            items[0].title = "홈"
            
            items[1].selectedImage = UIImage(systemName: "book.pages.fill")
            items[1].image = UIImage(systemName: "book.pages")
            items[1].title = "할일"
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

}
