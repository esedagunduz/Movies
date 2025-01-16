import Foundation
import UIKit

class MovieTableCellViewModel {
    var id: Int
    var name: String
    var date: String
    var rating: String
    var imageUrl: URL?
    var overview: String
    var backdropPath: URL?
    var dates: String?

    init(id: Int, name: String, date: String, rating: String, imageUrl: URL?, overview: String) {
        self.id = id
        self.name = name
        self.date = date
        self.rating = rating
        self.imageUrl = imageUrl
        self.overview = overview
        self.backdropPath = imageUrl // Assuming the same URL for backdropPath
    }
    
    init(movie: Movie) {
        self.id = movie.id
        self.name = movie.title ?? movie.name ?? ""
        self.rating = "\(movie.voteAverage)/10"
        self.date = movie.releaseDate ?? movie.firstAirDate ?? ""
        self.overview = movie.overview ?? ""
        self.imageUrl = makeImageURL(movie.posterPath ?? "")
        self.backdropPath = makeImageURL(movie.backdropPath ?? "")
    }
    
    init(movieUp: MovieUpcoming) {
        self.id = movieUp.id
        self.name = movieUp.title
        self.rating = "\(movieUp.voteAverage)/10"
        self.date = movieUp.releaseDate // You might want to use this or format it if needed
        // Store the minimum date from Dates
        self.overview = movieUp.overview
        self.imageUrl = makeImageURL(movieUp.posterPath ?? "")
        self.backdropPath = makeImageURL(movieUp.backdropPath ?? "")
    }
   
    private func makeImageURL(_ imageCode: String) -> URL? {
        URL(string: "\(NetworkConstants.shared.imageServerAddress)\(imageCode)")
    }
}
