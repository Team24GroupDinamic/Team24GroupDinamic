//
//  CheckInViewController.swift
//  CheckInApp
//
//  Created by Тимур on 20/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit
import WebKit

final class CheckInViewController: UIViewController {

    private let wkWebView = WKWebView()
    private var url: URL
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = wkWebView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let urlRequest = URLRequest(url: url)
        wkWebView.load(urlRequest)
    }

}
