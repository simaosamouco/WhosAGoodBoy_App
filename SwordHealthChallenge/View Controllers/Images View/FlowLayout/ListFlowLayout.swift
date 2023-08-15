//
//  ListFlowLayout.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 11/08/2023.
//

import Foundation
import UIKit

class ListFlowLayout: UICollectionViewFlowLayout {
    let spacing: CGFloat = 10
    let itemHeight: CGFloat = 100
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        minimumInteritemSpacing = spacing
        minimumLineSpacing = spacing
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
            itemSize = CGSize(width: availableWidth, height: itemHeight)
        }
    }
}

