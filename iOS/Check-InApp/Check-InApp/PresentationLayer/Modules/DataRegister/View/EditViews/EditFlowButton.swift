//
//  EditFlowButton.swift
//  CheckInApp
//
//  Created by Тимур on 15/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

class EditFlowButton: UIButton {

    private lazy var flowImageView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        let side = bounds.width
        flowImageView.frame = CGRect(x: side * 0.2, y: side * 0.2, width: side * 0.6, height: side * 0.6)
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }

    func setImage(named: String) {
        flowImageView.image = UIImage(named: named)
    }
}
