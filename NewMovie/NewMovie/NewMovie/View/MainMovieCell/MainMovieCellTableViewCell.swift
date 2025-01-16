import UIKit
import SnapKit
import SDWebImage

class MainMovieCell: UITableViewCell {

    public static var identifier: String {
        return "MainMovieCell"
    }

    public static func register() -> UINib {
        return UINib(nibName: "MainMovieCell", bundle: nil)
    }

    private let backView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray
        return view
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .orange
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(backView)
        backView.addSubview(movieImageView)
        backView.addSubview(nameLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(rateLabel)
    }

    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        movieImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.width.equalTo(movieImageView.snp.height)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(movieImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
        }

        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel.snp.leading)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    func setupCell(vieWModel: MovieTableCellViewModel) {
        nameLabel.text = vieWModel.name
        dateLabel.text = vieWModel.date
        rateLabel.text = vieWModel.rating
        movieImageView.sd_setImage(with: vieWModel.imageUrl)
    }
}
