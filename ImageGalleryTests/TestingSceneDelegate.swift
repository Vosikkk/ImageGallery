//
//  TestingSceneDelegate.swift
//  ImageGalleryTests
//
//  Created by Саша Восколович on 05.02.2024.
//

import UIKit
@testable import ImageGallery
class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(identifier: String(describing: GalleriesTableViewController.self))
        
        window?.rootViewController = controller
        
        window?.makeKeyAndVisible()
    }
}
