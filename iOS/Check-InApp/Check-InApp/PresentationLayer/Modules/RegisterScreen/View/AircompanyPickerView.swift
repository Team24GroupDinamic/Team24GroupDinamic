//
//  AircompanyPickerView.swift
//  CheckInApp
//
//  Created by Тимур on 17/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

class AircompanyPickerView: UIView {

    var picker: UIPickerView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        isOpaque = false
        backgroundColor = .black
        backgroundColor = backgroundColor?.withAlphaComponent(0.5)
        picker = UIPickerView(frame: CGRect.zero)
        addSubview(picker)
        let a: CGFloat = 0.8
        let b: CGFloat = 0.4
        let width = bounds.width * a
        let height = bounds.width * b
        let rect = CGRect(x: bounds.width * (1 - a) / 2, y: bounds.height * (1 - b) / 2, width: width, height: height)
        picker.frame = rect
        picker.backgroundColor = .white
        picker.layer.cornerRadius = width * 0.05
        picker.clipsToBounds = true
        picker.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0.1,
                       usingSpringWithDamping: 0.2, initialSpringVelocity: 10,
                       options: .curveEaseInOut, animations: {
            self.picker.transform = .identity
        }, completion: nil)
    }
}
