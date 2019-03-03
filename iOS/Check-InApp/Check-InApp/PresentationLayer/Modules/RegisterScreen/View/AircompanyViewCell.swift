//
//  AircompanyViewCell.swift
//  CheckInApp
//
//  Created by Тимур on 28/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class AircompanyViewCell: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    var url: URL? {
        didSet {
            loadLogoImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AircompanyViewCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }

    private func loadLogoImage() {
        guard let url = url else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                error == nil,
                let image = UIImage(data: data),
                url == self.url else { return }
            DispatchQueue.main.async {
                self.logoImageView.image = image
            }
        }
        dataTask.resume()
    }
}
