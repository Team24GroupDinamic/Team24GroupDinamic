//
//  DigitView.swift
//  CheckInApp
//
//  Created by Тимур on 27/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class DigitViewControl: UIControl {

    private enum Consts {
        static let fontSize: CGFloat = 20
        static let borderWidth: CGFloat = 3
        static let tintColor: UIColor = .white
    }

    var digit: Int? {
        didSet {
            guard let digit = digit else { return }
            digitLabel.text = "\(digit)"
            digitLabel.sizeToFit()
        }
    }
    var digitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Consts.fontSize)
        label.textAlignment = .center
        label.textColor = Consts.tintColor
        label.text = ""
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        digitLabel.frame = bounds
        layer.cornerRadius = bounds.width / 2
    }

    func commonInit() {
        addSubview(digitLabel)
        clipsToBounds = true
        layer.borderWidth = Consts.borderWidth
        layer.borderColor = Consts.tintColor.cgColor
    }
}
