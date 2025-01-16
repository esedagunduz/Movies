import UIKit
import SnapKit

protocol AddFilmViewControllerDelegate: AnyObject {
    func didAddFilm(_ film: MovieTableCellViewModel)
    func didUpdateFilm(_ film: MovieTableCellViewModel)
    func didDeleteFilm(_ film: MovieTableCellViewModel)
}

class AddFilmViewController: UIViewController {

    // UI Elements
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Movie Title"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.text = "Enter Movie Description"
        return textView
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    // Properties
    var viewModel: MovieTableCellViewModel?
    weak var delegate: AddFilmViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }

    private func configureView() {
        if let viewModel = viewModel {
            titleTextField.text = viewModel.name
            descriptionTextView.text = viewModel.overview
            saveButton.setTitle("Update", for: .normal)
        } else {
            saveButton.setTitle("Add", for: .normal)
        }
    }

    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Title and description cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let movie = MovieTableCellViewModel(
            id: viewModel?.id ?? UUID().hashValue,
            name: title,
            date: viewModel?.date ?? "",
            rating: viewModel?.rating ?? "",
            imageUrl: viewModel?.imageUrl,
            overview: description
        )

        if viewModel != nil {
            delegate?.didUpdateFilm(movie)
            NotificationCenter.default.post(name: .filmUpdated, object: movie)
        } else {
            delegate?.didAddFilm(movie)
            NotificationCenter.default.post(name: Notification.Name("filmAdded"), object: movie)
        }

        navigationController?.popToRootViewController(animated: true)
    }
}
