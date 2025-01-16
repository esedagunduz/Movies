import UIKit
import SnapKit

class MainViewController: UIViewController {

    private let tableView = UITableView()
    private let starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("★", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        return button
    }()
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Film", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(addFilmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var viewModel: MainViewModel = MainViewModel()
    var apiMovies: [MovieTableCellViewModel] = []
    var userAddedMovies: [MovieTableCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
        view.addSubview(starButton)
        setupStarButtonConstraints()

        NotificationCenter.default.addObserver(self, selector: #selector(handleFilmDeletion(_:)), name: .didDeleteFilm, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilmUpdated(_:)), name: .filmUpdated, object: nil)
    }

    func configView() {
        title = "Top Trending Movies"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(addButton)

        setupTableView()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }

    func bindViewModel() {
        viewModel.isLoadingData.bind { [weak self] isLoading in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async {
                // Handle activity indicator start/stop if needed
            }
        }

        viewModel.cellDataSouce.bind { [weak self] movies in
            guard let self = self, let movies = movies else { return }
            self.apiMovies = movies
            self.reloadTableView()
        }
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-20)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setupStarButtonConstraints() {
        starButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(50)
        }
    }

    @objc func starButtonTapped() {
        let upcomingVC = UpcomingFilmsViewController()
        navigationController?.pushViewController(upcomingVC, animated: true)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(MainMovieCell.self, forCellReuseIdentifier: MainMovieCell.identifier)
    }

    @objc func addFilmButtonTapped() {
        let addFilmVC = AddFilmViewController()
        addFilmVC.delegate = self
        navigationController?.pushViewController(addFilmVC, animated: true)
    }

    @objc func handleFilmUpdated(_ notification: Notification) {
        guard let film = notification.object as? MovieTableCellViewModel else { return }
        didUpdateFilm(film)
    }

    @objc func handleFilmDeletion(_ notification: Notification) {
        guard let film = notification.object as? MovieTableCellViewModel else { return }
        didDeleteFilm(film)
    }

    func didUpdateFilm(_ film: MovieTableCellViewModel) {
        if let index = userAddedMovies.firstIndex(where: { $0.id == film.id }) {
            userAddedMovies[index] = film
            reloadTableView()
            
            let alert = UIAlertController(title: "Success", message: "Film updated successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    func didDeleteFilm(_ film: MovieTableCellViewModel) {
        if let index = userAddedMovies.firstIndex(where: { $0.id == film.id }) {
            userAddedMovies.remove(at: index)
            reloadTableView()
            
            let alert = UIAlertController(title: "Success", message: "Film deleted successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func openDetails(movie: MovieTableCellViewModel, isUserAdded: Bool) {
        let movieModel = Movie(
            backdropPath: movie.backdropPath?.absoluteString,
            id: movie.id,
            title: movie.name,
            originalTitle: nil,
            overview: movie.overview,
            popularity: nil,
            posterPath: movie.imageUrl?.absoluteString,
            releaseDate: movie.date,
            voteAverage: Double(movie.rating) ?? 0,
            voteCount: 0,
            name: movie.name,
            originalName: nil,
            firstAirDate: nil
        )
        let detailsViewModel = DetailsMovieViewModel(movie: movieModel, isUserAdded: isUserAdded)
        let controller = DetailsMovieViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiMovies.count + userAddedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieCell.identifier, for: indexPath) as? MainMovieCell else {
            return UITableViewCell()
        }
        
        let isUserAdded = indexPath.row >= apiMovies.count
        let viewModel = isUserAdded ? userAddedMovies[indexPath.row - apiMovies.count] : apiMovies[indexPath.row]
        cell.setupCell(vieWModel: viewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isUserAdded = indexPath.row >= apiMovies.count
        let viewModel = isUserAdded ? userAddedMovies[indexPath.row - apiMovies.count] : apiMovies[indexPath.row]
        openDetails(movie: viewModel, isUserAdded: isUserAdded)
    }
}

extension MainViewController: AddFilmViewControllerDelegate {
    func didAddFilm(_ film: MovieTableCellViewModel) {
        userAddedMovies.append(film)
        reloadTableView()
    }
    
  
}

extension Notification.Name {
    static let didDeleteFilm = Notification.Name("didDeleteFilm")
    static let filmUpdated = Notification.Name("filmUpdated")
}
