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
    
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        return tb
    }()
    
    private let bag = DisposeBag()
    
    var viewModel: NamesViewModel!
    
    init(viewModel: NamesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getDogsList()
        setUpViews()
        bindTableView()
        self.view.backgroundColor = .systemBackground
        
    }
    
    private func bindTableView() {
        tableView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dogCell")
        viewModel.dogsList.bind(to: tableView.rx.items(cellIdentifier: "dogCell", cellType: UITableViewCell.self)) { (row, dog, cell) in
            if let dogg = dog.breeds.first {
                cell.textLabel?.text = dogg?.name
            }
        }.disposed(by: bag)
        
    }
    
    private func setUpViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension NamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
