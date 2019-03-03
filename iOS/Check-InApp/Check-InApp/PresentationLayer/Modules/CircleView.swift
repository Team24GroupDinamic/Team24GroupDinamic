//
//  CircleView.swift
//  CheckInApp
//
//  Created by Тимур on 27/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class CircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
