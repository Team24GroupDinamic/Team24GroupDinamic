//
//  RootAssembly.swift
//  CheckInApp
//
//  Created by Тимур on 05/01/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly()
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
