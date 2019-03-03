//
//  Executor.swift
//  CheckInApp
//
//  Created by Тимур on 11/02/2019.
//  Copyright © 2019 Тимур. All rights reserved.
//

import Foundation

final class Executor {

    private let session = URLSession.shared

    func execute(urlRequest: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        let dataTask = session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { completion(.failure(DataError())); return }
            print(String.init(data: data, encoding: .utf8))
            completion(.success(data))
        }
        dataTask.resume()
    }
}

final class DataError: Swift.Error {
    var localizedDescription: String {
        return "Некорректные данные с сервера"
    }
}
