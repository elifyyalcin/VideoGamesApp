//
//  TabBarViewController.swift
//  VideoGamesApp
//
//  Created by Elif Yalçın on 4.06.2022.
//

import UIKit

class TabBarViewController: UIViewController {
    
    private let tabBarVC = UITabBarController()
    private let homeVC = HomeViewController()
    private let favoriteVC = FavoriteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup() {
        
        homeVC.title = "Home"
        homeVC.tabBarItem.image = UIImage(named: "home")
        favoriteVC.title = "Favorites"
        favoriteVC.tabBarItem.image = UIImage(named: "fav")
        
        tabBarVC.setViewControllers([homeVC, favoriteVC], animated: false)
        
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }
}
