//
//  RegisterContentView.swift
//  CheckInApp
//
//  Created by Тимур on 15/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

class RegisterContentView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var flightNumberTextField: UITextField!
    @IBOutlet var aircompanyNameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RegisterContentView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width * 0.05
        clipsToBounds = true
    }
}
