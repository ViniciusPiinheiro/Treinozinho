//
//  MoviesManager.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import Foundation

class MoviesManager {
    private(set) var movies: [Movie]
    private static var privateShared: MoviesManager?
        
    class var shared: MoviesManager {
        guard let uwShared = privateShared else {
            privateShared = MoviesManager()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    private init() {
        movies = []
    }
    
    public func getMovies() {
        OperationsAPI.getMovies { (movies, error) in
            if error != nil {
                NotificationCenter.default.post(name: Notification.Name("serverError"), object: nil)
            } else {
                self.movies.removeAll()
                guard let movies = movies else {
                    self.movies = []
                    return
                }
                self.movies = movies
                NotificationCenter.default.post(name: Notification.Name("moviesSucess"), object: movies)
            }
        }
    }
}
