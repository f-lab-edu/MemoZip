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
        /*
        let flowLayout = UICollectionViewFlowLayout()
        
        let mainViewController = ReminderListViewController(collectionViewLayout: flowLayout) // 맨 처음 보여줄 ViewController
        
        // 앱을 시작할 때 루트 뷰 컨트롤러를 생성하고 UINavigationController에 추가합니다.
        let navigationController = UINavigationController(rootViewController : mainViewController) // 실제로 사용하는 뷰 컨트롤러의 클래스명
        
        // NavigationController에 처음으로 보여질 화면을 rootView로 지정
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
         */
        let tabBarController = UITabBarController()
        
        let reminderListViewController = UINavigationController(rootViewController: ReminderListViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //let reactor = HomeViewReactor()
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
