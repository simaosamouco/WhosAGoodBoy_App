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
        
        let namesViewModel = NamesViewModel(services: services)
        
        viewControllers = [
            createNavController(for: ImagesViewController(),
                                title: NSLocalizedString("Images", comment: ""),
                                image: UIImage(systemName: "photo.stack")!),
            createNavController(for: NamesViewController(viewModel: namesViewModel),
                                title: NSLocalizedString("Names", comment: ""),
                                image: UIImage(systemName: "a.magnify")!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
