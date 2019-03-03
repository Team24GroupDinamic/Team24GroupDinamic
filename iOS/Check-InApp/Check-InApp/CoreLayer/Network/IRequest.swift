//
//  IRequest.swift
//  CheckInApp
//
//  Created by Тимур on 11/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

enum RequstType: String {
    case get = "GET"
    case post = "POST"
}

class BaseRequest {

    func request() -> URLRequest {
        let urlString = mainURL() + service()
        guard let url = URL(string: urlString) else { fatalError("Cannot parse url string")}
        return URLRequest(url: url)
    }

    func mainURL() -> String {
        return "http://185.43.5.36:8080"
    }

    func service() -> String {
        return ""
    }

    func type() -> RequstType {
        return .get
    }

    func header() -> String {
        return ""
    }
}

protocol IModelRequest {
    associatedtype Model: Codable
}
