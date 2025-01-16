import Foundation
import UIKit
enum NetworkError: Error {
    case urlError
    case canNotParseData
}

public class APICaller {
    static let shared = APICaller()
    private init() {}
    
    private let apiKey = "a2808fe936ee607596786d126faebd67"
    static func getTrendingMovies(completionHandler: @escaping (_ result: Result<TrendingMovieModel, NetworkError>) -> Void) {
        if NetworkConstants.shared.apiKey.isEmpty {
            print("<!> API KEY is Missing <!>")
            print("<!> Get One from: https://www.themoviedb.org/ <!>")
            return
        }
        
        let urlString = NetworkConstants.shared.serverAddress +
        "trending/all/day?api_key=" +
        NetworkConstants.shared.apiKey
        
        guard let url = URL(string: urlString) else {
            completionHandler(Result.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            if err == nil,
               let data = dataResponse,
               let resultData = try? JSONDecoder().decode(TrendingMovieModel.self, from: data) {
                completionHandler(.success(resultData))
            } else {
                print(err.debugDescription)
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
    
    static func getMovieCredits(movieId: Int, completionHandler: @escaping (_ result: Result<MovieCredits, NetworkError>) -> Void) {
        let urlString = "\(NetworkConstants.shared.serverAddress)movie/\(movieId)/credits?api_key=\(NetworkConstants.shared.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, err in
            if err == nil, let data = dataResponse, let resultData = try? JSONDecoder().decode(MovieCredits.self, from: data) {
                completionHandler(.success(resultData))
            } else {
                print(err.debugDescription)
                completionHandler(.failure(.canNotParseData))
            }
        }.resume()
    }
    
    
    // Yeni method: getUpcomingMovies
    // APICaller.swift
    func getUpcomingMovies(page:Int, completion: @escaping (Result<UpcomingMoviesResponse, Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMjgwOGZlOTM2ZWU2MDc1OTY3ODZkMTI2ZmFlYmQ2NyIsIm5iZiI6MTcyMzU2OTAxMS44NzQyMTgsInN1YiI6IjY2YTFkNjEyOTdiODE3Njk1ODUyYmRjNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.TKLme4vlYvpr5OkVW7eg7gp5JfHY3OjJdM_hKqflTcI" // API anahtarınızı burada kullanın
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            // JSON'u decode etmeyi deneyin
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UpcomingMoviesResponse.self, from: data)
                print("API'den gelen veri:", response) // Terminalde yazdırma işlemi
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}


// MovieCredits Model
struct MovieCredits: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Codable {
    let name: String
    let character: String
}

struct Crew: Codable {
    let name: String
    let job: String
}

// Örnek kullanım:


