//
//  ViewController.swift
//  PicsumApp
//
//  Created by Марк Михайлов on 25.03.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    private func createTabBar () {
        let randomVC = UINavigationController(rootViewController: RandomViewController())
        randomVC.title = "Random"
        randomVC.tabBarItem.image = UIImage(systemName: "photo")
        
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem.image = UIImage(systemName: "star.fill")
        
        setViewControllers([randomVC, favoritesVC], animated: false)
        modalPresentationStyle = .fullScreen
    }
}

