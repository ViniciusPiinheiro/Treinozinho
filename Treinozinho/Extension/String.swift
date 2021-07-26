//
//  String.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 26/07/21.
//

import Foundation

extension String {
    static var statusError: String {
        return "%@ \n error: %@, description: %@, userInfo: %@"
    }
    static var format: String {
        return "%@"
    }
}
