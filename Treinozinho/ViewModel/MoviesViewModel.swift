//
//  MoviesViewModel.swift
//  Treinozinho
//
//  Created by Vinícius Pinheiro on 21/07/21.
//

import UIKit

protocol tableViewActionHandle {
    func reloadDataToTableView()
}

class MoviesViewModel {
    
    public let moviesManager = MoviesManager.shared
    private var movies = [Movie]()
    public let coreDataManagerObject = CoreDataManagerObject.shared
    
    public func fetchPhoto() {
        movies = []
        if coreDataManagerObject.movies.isEmpty {
            DispatchQueue.main.async {
                let movieCollection = self.moviesManager.movies
                movieCollection.forEach { (movie) in
                    self.movies.append(movie)
                    self.coreDataManagerObject.saveObjectInCoreData(object: movie)
                }
            }
        } else {
            DispatchQueue.main.async {
                let movieCollection = self.coreDataManagerObject.movies
                movieCollection.forEach { movie in
                    self.movies.append(movie)
                }
            }
        }
        
    }
}
