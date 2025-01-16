import UIKit

class UpcomingFilmsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var upcomingMovies: [MovieTableCellViewModel] = []
    private var isLoading: Bool = false
    private var totalPages = 1
    private var fetchedMoviesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming Films"
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchUpcomingMovies()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainMovieCell.self, forCellReuseIdentifier: MainMovieCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchUpcomingMovies(page: Int = 1, allMovies: [MovieUpcoming] = []) {
        guard !isLoading else { return }
        isLoading = true
        
        APICaller.shared.getUpcomingMovies(page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    // Combine existing movies with new ones
                    var updatedMovies = allMovies
                    updatedMovies.append(contentsOf: response.results)
                    
                    // Update totalPages from the response
                    let totalPages = response.total_pages
                    
                    // Filter movies to keep only those released after the current date
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let filteredMovies = updatedMovies.filter { movie in
                        guard let releaseDate = dateFormatter.date(from: movie.releaseDate) else {
                            return false
                        }
                        return releaseDate > currentDate
                    }
                    
                    // Check if we have at least 20 movies
                    if filteredMovies.count < 20 && page < totalPages {
                        // Fetch next page
                        self?.fetchUpcomingMovies(page: page + 1, allMovies: updatedMovies)
                    } else {
                        // Finalize and update the table view
                       
                        
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("Failed to fetch upcoming movies: \(error)")
                }
            }
        }
    }


}

extension UpcomingFilmsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieCell.identifier, for: indexPath) as? MainMovieCell else {
            return UITableViewCell()
        }
        let viewModel = upcomingMovies[indexPath.row]
        cell.setupCell(vieWModel: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = upcomingMovies[indexPath.row]
        // Filmin detaylarına gitme işlemini buradan yapabilirsiniz
    }
}
