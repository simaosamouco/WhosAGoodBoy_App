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

class ImagesViewController: UIViewController, UICollectionViewDelegate {
    
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
        bt.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        bt.tintColor = .white
        bt.backgroundColor = .black
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(switchLayoutPressed(_:)), for: .touchUpInside)
        bt.layer.cornerRadius = 25
        bt.layer.shadowColor = UIColor.black.cgColor
        bt.layer.shadowOpacity = 0.8
        bt.layer.shadowOffset = CGSize(width: 5, height: 5)
        bt.layer.shadowRadius = 5
        bt.layer.cornerRadius = 25
        bt.layer.borderWidth = 0.5
        return bt
    }()
    
    private lazy var orderButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "textformat.abc"), for: .normal)
        bt.tintColor = .white
        bt.backgroundColor = .black
        bt.setTitleColor(.white, for: .normal)
        bt.addTarget(self, action: #selector(orderPressed(_:)), for: .touchUpInside)
        bt.layer.cornerRadius = 25
        bt.layer.cornerRadius = 25
        bt.layer.shadowColor = UIColor.black.cgColor
        bt.layer.shadowOpacity = 0.8
        bt.layer.shadowOffset = CGSize(width: 5, height: 5)
        bt.layer.shadowRadius = 5
        bt.layer.cornerRadius = 25
        bt.layer.borderWidth = 0.5
        return bt
    }()
    
    var listLayout = ListFlowLayout()
    var gridLayout = GridFlowLayout()
    
    var isGridLayout: Bool = true {
        didSet {
            self.button.setImage(self.isGridLayout ?
                                 UIImage(systemName: "line.3.horizontal") :
                                    UIImage(systemName: "square.grid.3x3"),
                                 for: .normal)
        }
    }

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
        collectionVieww.delegate = self
        setUpViews()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionVieww.reloadData()
    }
    
    func setUpBindings() {
        viewModel.dogsProfileList
            .bind(to: collectionVieww.rx.items(cellIdentifier: "dogCell", cellType: DogImageCollectionViewCell.self)) { [weak self] index, dog, cell in
                //guard let self = self else { return } // Capture self strongly
                
                cell.backgroundColor = .systemBackground
                cell.layer.cornerRadius = 15
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowOffset = CGSize(width: 5, height: 5)
                cell.layer.shadowRadius = 5
                cell.layer.cornerRadius = 5
                cell.layer.borderWidth = 0.5
                
                cell.nameLabel.text = dog.breedName
                cell.imageView.image = dog.image
            }
            .disposed(by: bag)
        collectionVieww.rx.modelSelected(DogProfile.self).subscribe(onNext: { dogProfile in
            print(dogProfile.breedName)
            self.viewModel.cellSelected(dogProfile)
        }).disposed(by: bag)
        
        viewModel.actionNavigateToDetailView
                    .subscribe(onNext: { [weak self] vc in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                    .disposed(by: bag)
    }
    
    func setUpViews() {
        view.addSubview(collectionVieww)
        view.addSubview(button)
        view.addSubview(orderButton)
        collectionVieww.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(orderButton.snp.top).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        orderButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
    }
    
    @objc func switchLayoutPressed(_ sender: UIButton) {
        isGridLayout.toggle()
        let layout = isGridLayout ? gridLayout : listLayout
        collectionVieww.collectionViewLayout.invalidateLayout()
        collectionVieww.setCollectionViewLayout(layout, animated: true)
    }
    
    @objc func orderPressed(_ sender: UIButton) {
        viewModel.orderListAlphabetically()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let distanceFromBottom = contentHeight - offsetY
//
//        if distanceFromBottom < scrollView.bounds.height {
//            //fetchMoreData()
//        }
//    }
    
    
    
}
