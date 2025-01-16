import Foundation

class DetailsMovieViewModel {
    var movie: Movie
    var movieImage: URL?
    var movieTitle: String
    var movieDescription: String
    var movieId: Int
    var isUserAdded: Bool
    private(set) var cast: [Cast] = []
      private(set) var crew: [Crew] = []
    init(movie: Movie, isUserAdded: Bool) {
        self.movie = movie
        self.isUserAdded = isUserAdded
        self.movieId = movie.id
        self.movieTitle = movie.title ?? movie.name ?? ""
        self.movieDescription = movie.overview ?? ""
        self.movieImage = makeImageURL(movie.backdropPath)
    }

    private func makeImageURL(_ imagePath: String?) -> URL? {
        guard let imagePath = imagePath, !imagePath.isEmpty else {
            return nil
        }
        return URL(string: "\(NetworkConstants.shared.imageServerAddress)\(imagePath)")
    }

    func updateMovieDetails(title: String, description: String) {
        self.movieTitle = title
        self.movieDescription = description
        NotificationCenter.default.post(name: .filmUpdated, object: nil)
    }


    func deleteMovie() {
        NotificationCenter.default.post(name: .didDeleteFilm, object: movie)
    }
    func fetchMovieCredits(completion: @escaping () -> Void) {
        APICaller.getMovieCredits(movieId: movie.id) { [weak self] result in
            switch result {
            case .success(let credits):
                DispatchQueue.main.async {
                    self?.cast = credits.cast
                    self?.crew = credits.crew
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
