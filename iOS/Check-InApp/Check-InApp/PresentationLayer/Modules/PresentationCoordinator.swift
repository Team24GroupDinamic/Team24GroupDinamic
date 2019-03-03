//
//  PresentationCoordinator.swift
//  CheckInApp
//
//  Created by Тимур on 27/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

final class ApplicationCoordinator: Coordinator {

    lazy var rootViewController = presentationAssembly.getLoginViewController()
    var currentController: UIViewController?
    let presentationAssembly: IPresentationAssembly = PresentationAssembly()
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = rootViewController
        rootViewController.completion = { [weak self] in
            guard let self = self else { return }
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [
                self.presentationAssembly.getRegisterVC().wrappedInNavigation.withTabbarItem(with: "airplaneTab"),
                self.presentationAssembly.getDataRegisterVC().withTabbarItem(with: "id-card")
            ]
            self.rootViewController.present(tabBarController, animated: false, completion: nil)
        }
        window.makeKeyAndVisible()
        if !UserDefaults.standard.bool(forKey: "isWatchingOnboard") {
            let onboardVC = presentationAssembly.getOnboardVC()
            rootViewController.present(onboardVC, animated: true, completion: nil)
        }
    }

}
