//
//  NamesViewController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NamesViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var loaderView: SpinningLoaderView = {
        let view = SpinningLoaderView()
        view.startAnimating()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        return tb
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Who's a good boy?"
        sb.layer.cornerRadius = 15
        sb.layer.borderWidth = 0.5
        sb.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).cgColor
        return sb
    }()
    
    private let bag = DisposeBag()
    var viewModel: NamesViewModel!
    
    // MARK: - Initializers
    
    init(viewModel: NamesViewModel) {
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
        setUpBinding()
        viewModel.getDogsList()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Binding
    
    private func setUpBinding() {
        
        tableView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        
        tableView.register(DogNameTableViewCell.self, forCellReuseIdentifier: "dogCell")
        
        searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: bag)
        
        viewModel.filteredDogsList
            .bind(to: tableView.rx.items(cellIdentifier: "dogCell", cellType: DogNameTableViewCell.self)) { [weak self] _, dog, cell in
                self?.loaderView.isHidden = true
                cell.dogNameLabel.text = dog.breedName
                cell.groupLabel.text = dog.breedGroup
                cell.originLabel.text = dog.origin
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(DogProfile.self)
            .subscribe(onNext: { [weak self] dogProfile in
                self?.viewModel.cellSelected(dogProfile)
            })
            .disposed(by: bag)
        
        viewModel.navigateToDetailView
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        viewModel.somethingWentWrong()
            .subscribe(onNext: { [weak self] in
                self?.showSomethingWentWrongWarning()
            })
            .disposed(by: bag)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loaderView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(tableView.snp.top).offset(-8)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom).offset(8)
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showSomethingWentWrongWarning() {
        let alertController = UIAlertController(title: "Something Went Wrong...", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate Extension

extension NamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
