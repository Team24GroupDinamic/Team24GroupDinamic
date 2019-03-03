//
//  Locator.swift
//  CheckInApp
//
//  Created by Тимур on 20/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

final class Locator {
    private init() { }
    static let shared = Locator()

    lazy var storage: IStorage = {
        return Storage()
    }()

    func requestManager() -> IRequestManager {
        return RequestManager()
    }

    func executor() -> Executor {
        return Executor()
    }
}
