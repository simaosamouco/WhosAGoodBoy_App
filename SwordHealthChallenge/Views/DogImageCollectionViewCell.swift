//
//  DogImageCollectionViewCell.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 11/08/2023.
//

import Foundation
import UIKit
import SnapKit

class DogImageCollectionViewCell: UICollectionViewCell {
    
    let labelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(labelView)
        labelView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(contentView.snp.height)
            make.leading.equalTo(contentView.snp.leading)
            make.bottom.top.equalTo(contentView)
        }
        
        labelView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(labelView).offset(4)
            make.trailing.bottom.equalTo(labelView).offset(-4)
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

        attributes.frame.size.height = ceil(size.height)
        return attributes
    }
}
