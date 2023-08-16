//
//  DogDetailViewController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 12/08/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DogDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var breedCatTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Breed Category: "
        lb.font = UIFont(name:"ArialRoundedMTBold", size: 18.0)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var breedCatLabel: UILabel = {
        let lb = UILabel()
        lb.text = viewModel.dogProfile.breedGroup
        lb.font = UIFont(name:"ArialRoundedMT", size: 16.0)
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var originTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Origin:"
        lb.font = UIFont(name:"ArialRoundedMTBold", size: 18.0)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var originLabel: UILabel = {
        let lb = UILabel()
        lb.text = viewModel.dogProfile.origin
        lb.font = UIFont(name:"ArialRoundedMT", size: 16.0)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var temperamentTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Temperament: "
        lb.font = UIFont(name:"ArialRoundedMTBold", size: 18.0)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var temperamentLabel: UILabel = {
        let lb = UILabel()
        lb.text = viewModel.dogProfile.temperament
        lb.font = UIFont(name:"ArialRoundedMT", size: 16.0)
        lb.textAlignment = .left
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var dataStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        sv.layer.cornerRadius = 25
        sv.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.4
        iv.layer.shadowOffset = CGSize(width: 0, height: 8)
        iv.layer.shadowRadius = 5
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = viewModel.dogProfile.breedName
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var barButtonItem: UIBarButtonItem!
    
    private let bag = DisposeBag()
    
    let viewModel: DogDetailViewModel
    
    // MARK: - Initialization
    
    init(viewModel: DogDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        barButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark") , style: .plain, target: self, action: #selector(manageDogInDatabase))
        barButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = barButtonItem
        setUpBinding()
        handleDogImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkIfDogIsInDatabase()
    }
    
    // MARK: - Binding
    
    func setUpBinding() {
        viewModel.isInDatabase
            .asObservable()
            .subscribe(onNext: { [weak self] isInDataBase in
                self?.updateBarButton(isInDataBase)
            })
            .disposed(by: bag)
    }
    
    // MARK: - UI Setup
    
    func setUpViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dataStackView)
        dataStackView.addArrangedSubview(breedCatTitleLabel)
        dataStackView.addArrangedSubview(breedCatLabel)
        dataStackView.addArrangedSubview(originTitleLabel)
        dataStackView.addArrangedSubview(originLabel)
        dataStackView.addArrangedSubview(temperamentTitleLabel)
        dataStackView.addArrangedSubview(temperamentLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            if let height = viewModel.dogProfile.image?.size.height, let width = viewModel.dogProfile.image?.size.width {
                make.height.equalTo(imageView.snp.width).multipliedBy(Double(height)/Double(width))
            }
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        dataStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func handleDogImage() {
        if let image = viewModel.dogProfile.image {
            self.imageView.image = image
            setUpViews()
            viewModel.checkIfDogIsInDatabase()
        } else {
            viewModel.fetchImageFromURL(completion: { [weak self] image in
                self?.viewModel.dogProfile.image = image
                self?.imageView.image = self?.viewModel.dogProfile.image
                self?.setUpViews()
                self?.viewModel.checkIfDogIsInDatabase()
            })
        }
    }
    
    private func updateBarButton(_ isInDataBase: Bool) {
        barButtonItem = UIBarButtonItem(image: isInDataBase ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(manageDogInDatabase))
        barButtonItem.tintColor = .black
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem = self.barButtonItem
        }
    }
    
    @objc func manageDogInDatabase(sender: UIButton) {
        viewModel.bookMarkButtonTapped()
    }
}
