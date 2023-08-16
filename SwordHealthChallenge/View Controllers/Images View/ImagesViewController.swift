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
    
    // MARK: - Properties
    
    private lazy var loaderView: SpinningLoaderView = {
        let view = SpinningLoaderView()
        view.startAnimating()
        return view
    }()
    
    private lazy var collectionViewFooterLoader: UIView = {
        let ui = UIView()
        let spinner = UIActivityIndicatorView()
        spinner.center = ui.center
        
        ui.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        spinner.startAnimating()
        return ui
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = gridLayout
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private lazy var switchLayoutButton: UIButton = {
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
    
    private lazy var orderAlphabeticallyButton: UIButton = {
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
    
    private var spinnerViewHeight: Constraint?
    private var isChangingLayout = false
    
    private var listLayout = ListFlowLayout()
    private var gridLayout = GridFlowLayout()
    private var isGridLayout: Bool = true {
        didSet {
            self.switchLayoutButton.setImage(self.isGridLayout ?
                                             UIImage(systemName: "line.3.horizontal") :
                                                UIImage(systemName: "square.grid.3x3"),
                                             for: .normal)
        }
    }
    
    private let bag = DisposeBag()
    var viewModel: ImagesViewModel!
    
    // MARK: - Initialization
    
    init(viewModel: ImagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.getDogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionViewFooterLoader)
        view.addSubview(collectionView)
        view.addSubview(switchLayoutButton)
        view.addSubview(orderAlphabeticallyButton)
        view.addSubview(loaderView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(collectionViewFooterLoader.snp.top)
        }
        switchLayoutButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(orderAlphabeticallyButton.snp.top).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        orderAlphabeticallyButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        collectionViewFooterLoader.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            spinnerViewHeight = make.height.equalTo(0).constraint
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        
        collectionView.register(DogImageCollectionViewCell.self, forCellWithReuseIdentifier: "dogCell")
        collectionView.delegate = self
        
        viewModel.dogsProfileList
            .bind(to: collectionView.rx.items(cellIdentifier: "dogCell", cellType: DogImageCollectionViewCell.self)) { index, dog, cell in
                cell.nameLabel.text = dog.breedName
                cell.imageView.image = dog.image
            }
            .disposed(by: bag)
        
        collectionView.rx.modelSelected(DogProfile.self)
            .subscribe(onNext: { [weak self] dogProfile in
                self?.viewModel.cellSelected(dogProfile)
            })
            .disposed(by: bag)
        
        viewModel.navigateToDetailView
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        viewModel.isFetching
            .subscribe(onNext: { [weak self] isFetching in
                if isFetching {
                    self?.collectionViewFooterLoader.isHidden = false
                    self?.spinnerViewHeight?.update(offset: 50)
                } else {
                    self?.loaderView.isHidden = true
                    self?.collectionViewFooterLoader.isHidden = true
                    self?.spinnerViewHeight?.update(offset: 0)
                }
            })
            .disposed(by: bag)
        
        viewModel.somethingWentWrong()
            .subscribe(onNext: { [weak self] in
                self?.showSomethingWentWrongWarning()
            })
            .disposed(by: bag)
        
    }
    
    // MARK: - Button Actions
    
    @objc private func switchLayoutPressed(_ sender: UIButton) {
        isGridLayout.toggle()
        let layout = isGridLayout ? gridLayout : listLayout
        isChangingLayout = true
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        isChangingLayout = false
    }
    
    @objc private func orderPressed(_ sender: UIButton) {
        viewModel.orderListAlphabetically()
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isChangingLayout {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = contentHeight - offsetY
        
        if distanceFromBottom + 100  < scrollView.bounds.height && viewModel.dogsProfileList.value.count != 0 {
            self.viewModel.getDogs()
        }
    }
    
    private func showSomethingWentWrongWarning() {
        let alertController = UIAlertController(title: "Something Went Wrong...", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
