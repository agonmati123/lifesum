//
//  AppDelegate.swift
//  Lifesum
//
//  Created by Agon Mati on 2022-05-02.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RandomFoodViewController(viewModel: RandomFoodViewModel())
        window?.makeKeyAndVisible()
        return true
    }
}
