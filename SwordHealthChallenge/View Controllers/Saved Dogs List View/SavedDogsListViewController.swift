//
//  SavedDogsListViewController.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 15/08/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SavedDogsListViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        return tb
    }()
    
    private lazy var loaderView: SpinningLoaderView = {
        let view = SpinningLoaderView()
        view.startAnimating()
        return view
    }()
    
    private lazy var emptyListLabel: UILabel = {
        let lb = UILabel()
        lb.text = "The List is Empty..."
        lb.backgroundColor = .systemBackground
        lb.textAlignment = .center
        return lb
    }()
    
    private let bag = DisposeBag()
    
    let viewModel: SavedDogsListViewModel
    
    // MARK: - Initialization
    
    init(viewModel: SavedDogsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpBinding()
        setupUI()
        viewModel.getDogsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getDogsList()
    }
    
    // MARK: - Binding
    
    private func setUpBinding() {
        
        tableView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        
        tableView.register(DogNameTableViewCell.self, forCellReuseIdentifier: "dogCell")
        
        viewModel.dogsProfileList
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
        
        viewModel.listIsEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] isEmpty in
                self?.emptyListLabel.isHidden = !isEmpty
            })
            .disposed(by: bag)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(loaderView)
        view.addSubview(emptyListLabel)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyListLabel.snp.makeConstraints { make in
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

extension SavedDogsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
