//
//  OnboardView.swift
//  CheckInApp
//
//  Created by Тимур on 26/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class OnboardView: UIView {
    private var wasAnimated = false

    private var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        return textLabel
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(text: String, imageName: String, frame: CGRect) {
        textLabel.text = text
        imageView.image = UIImage(named: imageName)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if textLabel.superview == nil {
            addSubview(textLabel)
        }
        if imageView.superview == nil {
            addSubview(imageView)
        }
        textLabel.frame = CGRect(x: bounds.width * 0.1,
                                 y: bounds.height * 0.05,
                                 width: bounds.width * 0.8,
                                 height: bounds.height * 0.2)
        imageView.frame = CGRect(x: 0,
                                 y: bounds.height * 0.2,
                                 width: bounds.width,
                                 height: bounds.height * 0.7)
    }

    func animate() {
        if !wasAnimated {
            imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut, animations: {
                self.imageView.transform = .identity
            }, completion: nil)
            wasAnimated = true
        }
    }
}
