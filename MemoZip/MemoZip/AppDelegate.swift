//
//  AppDelegate.swift
//  MemoZip
//
//  Created by 박세라 on 3/9/24.
//

import UIKit
import MyLibrary

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?        // window 프로퍼티 추가
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let mainViewController = ReminderListViewController(collectionViewLayout: flowLayout) // 맨 처음 보여줄 ViewController
        
        // 앱을 시작할 때 루트 뷰 컨트롤러를 생성하고 UINavigationController에 추가합니다.
        let navigationController = UINavigationController(rootViewController : mainViewController) // 실제로 사용하는 뷰 컨트롤러의 클래스명
        window = UIWindow(frame: UIScreen.main.bounds)
        // NavigationController에 처음으로 보여질 화면을 rootView로 지정
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}
