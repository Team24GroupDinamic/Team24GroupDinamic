//
//  IndicatorCirclesView.swift
//  CheckInApp
//
//  Created by Тимур on 27/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

final class IndicatorCirclesView: UIView {

    private enum Consts {
        static let defaultColor: UIColor = .darkGray
        static let indicatorColor: UIColor = .green
        static let spaceBetween: CGFloat = 5
    }

    var numberOfIndicators: Int? {
        didSet {
            guard let number = numberOfIndicators else { return }
            circlesView.forEach { $0.removeFromSuperview() }
            for _ in 0..<number {
                let circleView = CircleView()
                circleView.backgroundColor = .darkGray
                addSubview(circleView)
                circlesView.append(circleView)
            }
            layoutIndicators()
        }
    }

    var circlesView: [UIView] = []
    var currentNumber = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIndicators()
    }

    func addIndicator() {
        guard currentNumber < circlesView.count else { return }
        circlesView[currentNumber].backgroundColor = Consts.indicatorColor
        currentNumber += 1
    }

    func subtractIndicator() {
        guard currentNumber >= 0 else { return }
        circlesView[currentNumber - 1].backgroundColor = Consts.defaultColor
        currentNumber -= 1
    }

    func reset() {
        for _ in 0..<currentNumber {
            subtractIndicator()
        }
    }

    func layoutIndicators() {
        let spaceWidth = bounds.width
        guard let numberOfIndicators = numberOfIndicators else { return }
        let sideOfCircleView = (spaceWidth - Consts.spaceBetween * CGFloat(numberOfIndicators + 1)) / CGFloat(numberOfIndicators)
        var startXCoord: CGFloat = 0
        for i in 0..<circlesView.count {
            circlesView[i].frame = CGRect(x: startXCoord + Consts.spaceBetween,
                                          y: 0,
                                          width: sideOfCircleView,
                                          height: sideOfCircleView)
            startXCoord += Consts.spaceBetween + sideOfCircleView
        }
    }
}
