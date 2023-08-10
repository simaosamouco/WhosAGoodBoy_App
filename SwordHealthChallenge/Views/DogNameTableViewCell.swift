//
//  DogNameTableViewCell.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 10/08/2023.
//

import UIKit

class DogNameTableViewCell: UITableViewCell {
    
    let contentViewAux: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha: 1).cgColor
        return view
    }()
    
    let dogNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    let originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let originGroupStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 16
        return st
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        contentView.addSubview(contentViewAux)
        contentViewAux.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(16)
            make.trailing.bottom.equalTo(contentView).offset(-16)
        }
        
        contentViewAux.addSubview(dogNameLabel)
        
        contentViewAux.addSubview(originGroupStackView)
        originGroupStackView.addArrangedSubview(originLabel)
        originGroupStackView.addArrangedSubview(groupLabel)
        dogNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentViewAux).offset(16)
            make.centerY.equalTo(contentViewAux)
        }
        
        originGroupStackView.snp.makeConstraints { make in
            make.leading.equalTo(dogNameLabel.snp.trailing).offset(16)
            make.trailing.equalTo(contentViewAux.snp.trailing).offset(-16)
            make.centerY.equalTo(contentViewAux)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
