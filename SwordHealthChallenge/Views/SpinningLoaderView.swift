//
//  SpinningLoaderView.swift
//  SwordHealthChallenge
//
//  Created by Simão Neves Samouco on 13/08/2023.
//

import Foundation
import UIKit
import SnapKit

class SpinningLoaderView: UIView {
    
    private let loaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "dog_icon")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(loaderImageView)
        
        loaderImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    func startAnimating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        loaderImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimating() {
        loaderImageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
