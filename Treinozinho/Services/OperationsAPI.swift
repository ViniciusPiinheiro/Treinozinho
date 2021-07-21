//
//  HttpMethods.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import Foundation
import UIKit

class OperationsAPI {
    static var baseURL: String = "https://60f836a5ee56ef00179757fc.mockapi.io/"
    
    
    enum HttpMethods: String {
        case post = "POST"
        case get = "GET"
    }
    
    static public func getFrom(url: URL, completionHandler: ((_ data: Data?,  _ _error: Error?) -> Void)?) {
        self.makeRequest(url: url, method: .get, body: nil, completionHandler: completionHandler)
    }
    
    
    static private func makeRequest(url: URL, method: HttpMethods, body: Data?, completionHandler: ((_ data: Data?, _ error: Error?) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erro) in
            if let _ = erro {
                completionHandler?(data,erro)
            } else {
                completionHandler?(data, nil)
            }
        }.resume()
    }
    
    static public func getMovies(completionHandler: @escaping ((_ data:[Movies]?, _ error: Error?) -> Void)) {

        guard let url = URL(string: baseURL) else {
            print("URL error: Bad formatter")
            return completionHandler(nil, nil)
        }
        
        self.getFrom(url: url) { (data, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode([Movies].self, from: data)
                    completionHandler(movies, nil)
                } catch let jsonError {
                    print("Error: \(jsonError.localizedDescription)")
                    completionHandler(nil, jsonError)
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }

        }

    }
    
}
