import UIKit
import SnapKit
import SDWebImage

class DetailsMovieViewController: UIViewController {
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let movieImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let castHeaderLabel = UILabel()
    private let crewHeaderLabel = UILabel()
    private let castStackView = UIStackView()
    private let crewStackView = UIStackView()
    private let updateButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    // View model
    var viewModel: DetailsMovieViewModel

    init(viewModel: DetailsMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configView()
        fetchMovieCredits()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(castHeaderLabel)
        contentView.addSubview(castStackView)
        contentView.addSubview(crewHeaderLabel)
        contentView.addSubview(crewStackView)
        contentView.addSubview(updateButton)
        contentView.addSubview(deleteButton)

        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0

        descriptionLabel.numberOfLines = 0

        castHeaderLabel.text = "Starring"
        castHeaderLabel.font = .boldSystemFont(ofSize: 20)
        
        crewHeaderLabel.text = "Director(s)"
        crewHeaderLabel.font = .boldSystemFont(ofSize: 20)
        
        castStackView.axis = .vertical
        castStackView.spacing = 8
        castStackView.alignment = .fill
        
        crewStackView.axis = .vertical
        crewStackView.spacing = 8
        crewStackView.alignment = .fill

        updateButton.setTitle("Update", for: .normal)
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.backgroundColor = .systemGreen
        updateButton.layer.cornerRadius = 10
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)

        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        castHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        castStackView.snp.makeConstraints { make in
            make.top.equalTo(castHeaderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        crewHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(castStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        crewStackView.snp.makeConstraints { make in
            make.top.equalTo(crewHeaderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        updateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(updateButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    private func configView() {
        self.title = "Movie Details"
        titleLabel.text = viewModel.movieTitle
        descriptionLabel.text = viewModel.movieDescription
        movieImageView.sd_setImage(with: viewModel.movieImage)

        if viewModel.isUserAdded {
            updateButton.isHidden = false
            deleteButton.isHidden = false
        } else {
            updateButton.isHidden = true
            deleteButton.isHidden = true
        }
    }

    private func fetchMovieCredits() {
        viewModel.fetchMovieCredits { [weak self] in
            self?.updateCastAndCrewViews()
        }
    }

    private func updateCastAndCrewViews() {
        DispatchQueue.main.async {
            // Clear previous views
            self.castStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.crewStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Add cast views
            for cast in self.viewModel.cast {
                let label = UILabel()
                label.text = "\(cast.name) as \(cast.character)"
                self.castStackView.addArrangedSubview(label)
            }
            
            // Add crew views
            for crew in self.viewModel.crew {
                let label = UILabel()
                label.text = "\(crew.name) - \(crew.job)"
                self.crewStackView.addArrangedSubview(label)
            }
        }
    }


    @objc private func updateButtonTapped() {
        let addFilmVC = AddFilmViewController()
        addFilmVC.delegate = self
        addFilmVC.viewModel = MovieTableCellViewModel(
            id: viewModel.movieId,
            name: viewModel.movieTitle,
            date: "", // Set the appropriate date if needed
            rating: "", // Set the appropriate rating if needed
            imageUrl: viewModel.movieImage,
            overview: viewModel.movieDescription
        )
        navigationController?.pushViewController(addFilmVC, animated: true)
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Sil", message: "Bu filmi silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            // Film silme işlemi
            self.viewModel.deleteMovie()
            
            // Başarı mesajını göster
            let successAlert = UIAlertController(title: "Silme Başarılı", message: "Film başarıyla silindi.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                // Ana sayfaya yönlendir
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(successAlert, animated: true)
        }))
        present(alert, animated: true)
    }
}

extension DetailsMovieViewController: AddFilmViewControllerDelegate {
    func didAddFilm(_ film: MovieTableCellViewModel) {
        // Handle adding new film if necessary
    }

    func didUpdateFilm(_ film: MovieTableCellViewModel) {
        viewModel.updateMovieDetails(title: film.name, description: film.overview)
        configView()
    }

    func didDeleteFilm(_ film: MovieTableCellViewModel) {
        viewModel.deleteMovie()

        // Bildirim gönder
        NotificationCenter.default.post(name: .didDeleteFilm, object: film)

        // Geri dön
        navigationController?.popViewController(animated: true)
    }
}
