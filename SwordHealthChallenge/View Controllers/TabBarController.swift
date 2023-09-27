//
//  TabBarController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().tintColor = .black
        setUpVCs()
        
    }
    
    func setUpVCs() {
        
        let services = ServicesManager()
        let realm = RealmManager()
        let dogListManager = DogListManager()
        
        let namesViewModel = NamesViewModel(services: services, realm: realm, dogListManager: dogListManager)
        let imagesViewModel = ImagesViewModel(services: services, realm: realm, dogListManager: dogListManager)
        let savedDogsViewModel = SavedDogsListViewModel(service: services, realm: realm)
        
        viewControllers = [
            createNavController(for: ImagesViewController(viewModel: imagesViewModel),
                                title: "Images",
                                image: UIImage(systemName: "photo.stack")!),
            createNavController(for: NamesViewController(viewModel: namesViewModel),
                                title: "Names",
                                image: UIImage(systemName: "a.magnify")!),
            createNavController(for: SavedDogsListViewController(viewModel: savedDogsViewModel),
                                title: "Rescued Dogs",
                                image: UIImage(systemName: "bookmark.circle.fill")!)
        ]
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
