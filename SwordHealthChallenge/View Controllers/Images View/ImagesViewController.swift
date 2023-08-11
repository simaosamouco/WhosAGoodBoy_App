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
        cv.showsVerticalScrollIndicator = false
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

    var viewModel: ImagesViewModel!
    
    private let bag = DisposeBag()
    
    init(viewModel: ImagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.viewModel.getDogsList()
        collectionVieww.register(DogImageCollectionViewCell.self, forCellWithReuseIdentifier: "dogCell")
        setUpViews()
        setUpBindings() 
    }
    
    func setUpBindings() {
        viewModel.dogsList
            .bind(to: collectionVieww.rx.items(cellIdentifier: "dogCell", cellType: DogImageCollectionViewCell.self)) { [weak self] _, dog, cell in
                //guard let self = self else { return } // Capture self strongly
                
                cell.backgroundColor = .systemBackground
                cell.layer.cornerRadius = 15
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowOffset = CGSize(width: 5, height: 5)
                cell.layer.shadowRadius = 5
                cell.layer.cornerRadius = 5
                cell.layer.borderWidth = 0.5
                
                self?.viewModel.fetchImageFromURL(from: URL(string: dog.url)!){ image in
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    } else {
                        // Failed
                    }
                }
                
                if let dogBreed = dog.breeds.first {
                    cell.nameLabel.text = dogBreed?.name
                }
            }
            .disposed(by: bag)
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
