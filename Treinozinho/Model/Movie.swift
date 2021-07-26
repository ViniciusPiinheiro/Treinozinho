//
//  Movies.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import UIKit
import CoreData

class Movie: Decodable {
    public let movieTitle: String
    //public let movieGenres: [String]
    
    enum CodingKeys: String, CodingKey {
        case movieTitle
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movieTitle = try container.decode(String.self, forKey: .movieTitle)
    }
    
    required init (movie: NSManagedObject) {
        movieTitle = (movie.value(forKey: "movieTitle") as! String)
    }
    
}
