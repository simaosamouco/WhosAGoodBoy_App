//
//  ImagesViewController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ImagesViewController: UIViewController {
    
    private lazy var collectionVieww: UICollectionView = {
        let layout = gridLayout
        layout.scrollDirection = .vertical
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        cv.dataSource = self
        return cv
    }()
    
    private lazy var button: UIButton = {
        let bt = UIButton()
        bt.setTitle("Switch Layout", for: .normal)
        bt.backgroundColor = .black
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(switchLayoutPressed(_:)), for: .touchUpInside)
        return bt
    }()
    
    var listLayout = ListFlowLayout()
    var gridLayout = GridFlowLayout()
    
    var isGridLayout: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        collectionVieww.register(DogImageCollectionViewCell.self, forCellWithReuseIdentifier: "dogCell")
        setUpViews()
    }
    
    func setUpViews() {
        view.addSubview(collectionVieww)
        view.addSubview(button)
        collectionVieww.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(button.snp.top)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(collectionVieww.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc func switchLayoutPressed(_ sender: UIButton) {
        isGridLayout.toggle()
        let layout = isGridLayout ? gridLayout : listLayout
        collectionVieww.collectionViewLayout.invalidateLayout()
        collectionVieww.setCollectionViewLayout(layout, animated: true)
    }
}

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogCell", for: indexPath) as! DogImageCollectionViewCell
        
        cell.backgroundColor = .systemRed
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowRadius = 5
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.5
        cell.nameLabel.text = "Border Collie"
        cell.imageView.image = UIImage(systemName: "heart.fill")
        
        return cell
    }
}
