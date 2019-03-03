//
//  LoginViewController.swift
//  CheckInApp
//
//  Created by Тимур on 27/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit
import LocalAuthentication

final class LoginViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var indicatorCirclesView: IndicatorCirclesView!
    @IBOutlet var verticalStackView: UIStackView!

    var completion: (() -> Void)?
    var pass: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleLabel.text = "Введите пароль"
    }

    private func setupUI() {
        indicatorCirclesView.numberOfIndicators = 4
        var i = 1
        while i < 10 {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = 5
            let digitViews = [DigitViewControl(), DigitViewControl(), DigitViewControl()]
            digitViews.forEach { digitView in
                digitView.digit = i
                horizontalStackView.addArrangedSubview(digitView)
                digitView.addTarget(self,
                                    action: #selector(digitViewTapped(digitView:)),
                                    for: UIControl.Event.touchDown)
                i += 1
            }
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 5
        let fingerView = UIImageView()
        fingerView.image = UIImage(named: "fingerprint")
        let digitView = DigitViewControl()
        digitView.digit = 0
        digitView.addTarget(self, action: #selector(digitViewTapped(digitView:)), for: UIControl.Event.touchDown)
        let forbiddenView = UIImageView()
        forbiddenView.image = UIImage(named: "tag-with-cancel")
        fingerView.contentMode = .scaleAspectFit
        forbiddenView.contentMode = .scaleAspectFit
        horizontalStackView.addArrangedSubview(fingerView)
        horizontalStackView.addArrangedSubview(digitView)
        horizontalStackView.addArrangedSubview(forbiddenView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        if UserDefaults.standard.string(forKey: "passHash") == nil {
            fingerView.alpha = 0
        }
        let tapGestureForbidden = UITapGestureRecognizer(target: self, action: #selector(forbiddenTapped(gesture:)))
        forbiddenView.addGestureRecognizer(tapGestureForbidden)
        forbiddenView.isUserInteractionEnabled = true
        let tapGestureBiometry = UITapGestureRecognizer(target: self,
                                                        action: #selector(biometryWasTapped(gesture:)))
        fingerView.addGestureRecognizer(tapGestureBiometry)
        fingerView.isUserInteractionEnabled = true
    }

    @objc func digitViewTapped(digitView: DigitViewControl) {
        guard let digit = digitView.digit else { return }
        indicatorCirclesView.addIndicator()
        if pass.count < 4 {
            pass += "\(digit)"
        }
        if pass.count == 4 {
            if UserDefaults.standard.string(forKey: "passHash") == nil {
                UserDefaults.standard.set(pass.sha1(), forKey: "passHash")
                completion?()
            } else if UserDefaults.standard.string(forKey: "passHash") == pass.sha1() {
                completion?()
            } else {
                showAlert(message: "Не верный пароль")
                pass = ""
                indicatorCirclesView.reset()
            }
        }
    }

    @objc func forbiddenTapped(gesture: UIGestureRecognizer) {
        guard pass.count > 0 else { return }
        pass.removeLast()
        indicatorCirclesView.subtractIndicator()
    }

    @objc func biometryWasTapped(gesture: UITapGestureRecognizer) {
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "

        var authError: NSError?
        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     localizedReason: myLocalizedReasonString) { success, _ in

                DispatchQueue.main.async {
                    if success {
                        self.completion?()
                    } else {
                        self.showAlert(message: "Не удалось авторизоваться")
                    }
                }
            }
        } else {
            showAlert(message: "Ваше устройство не поддерживает")
        }
    }
}
