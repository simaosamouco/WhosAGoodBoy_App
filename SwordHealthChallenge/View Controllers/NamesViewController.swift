//
//  NamesViewController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import UIKit

class NamesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemCyan
        
        //Testing getDogsList
        let services = ServicesManager()
        services.getDogsList(completion: { [weak self] result in
            switch result {
            case .success(let dogs):
                print(dogs.count)
            case .failure(let error):
                print("Error retrieving Picture of the Day: \(error.localizedDescription)")
            }
        })
    }
}
