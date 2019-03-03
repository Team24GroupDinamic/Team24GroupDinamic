//
//  OnboardViewController.swift
//  CheckInApp
//
//  Created by Тимур on 26/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var onboardScollView: UIScrollView!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var pageControl: UIPageControl! {
        didSet {
            guard let pageControl = pageControl else { return }
            pageControl.numberOfPages = onboardsData.count
        }
    }
    var onboardsData = [("Регистрируйтесь на рейс в одно нажатие", "smartphone"), ("fdsf", "smartphone")]
    var onboardsView: [OnboardView] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        onboardsView[0].animate()
    }

    // MARK: - Private

    private func setupUI() {
        var i: CGFloat = 0
        for onboardData in onboardsData {
            let onboardView = OnboardView(text: onboardData.0,
                                          imageName: onboardData.1,
                                          frame: CGRect(x: i * onboardScollView.bounds.width,
                                                        y: 0, width: onboardScollView.bounds.width,
                                                        height: onboardScollView.bounds.height))
            onboardScollView.addSubview(onboardView)
            onboardsView.append(onboardView)
            i += 1
        }
        onboardScollView.contentSize.width = onboardScollView.bounds.width * CGFloat(i+1)
        onboardsData = []
        finishButton.layer.cornerRadius = finishButton.bounds.width * 0.05
        finishButton.clipsToBounds = true
    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isWatchingOnboard")
        dismiss(animated: true, completion: nil)
    }

    // MARK: - ScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentWidth = Int(scrollView.contentSize.width)
        let pageWidth = Int(scrollView.bounds.width)
        let currentNumber = contentWidth / pageWidth - 1
        pageControl.currentPage = currentNumber
        if contentWidth % pageWidth == 0 {
            onboardsView[contentWidth / pageWidth].animate()
        }
    }
}
