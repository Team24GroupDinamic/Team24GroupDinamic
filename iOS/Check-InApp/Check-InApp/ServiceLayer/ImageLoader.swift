//
//  ImageLoader.swift
//  CheckInApp
//
//  Created by Тимур on 28/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

protocol IImageLoader {
    func loadImageURL(url: URL, completion: @escaping (UIImage?) -> Void)
}
