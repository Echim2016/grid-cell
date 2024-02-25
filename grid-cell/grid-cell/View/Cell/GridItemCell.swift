//
//  GridItemCell.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import UIKit

final class GridItemCell: UICollectionViewCell {
  
  var renderedImage: Data? {
    baseImageView.image?.pngData()
  }
  
  var renderedMainText: String? {
    mainLabel.text
  }
  
  var renderedSubtitleText: String? {
    subtitleLabel.text
  }
  
  private lazy var baseImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var baseVStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 4.0
    stackView.addArrangedSubview(mainLabel)
    stackView.addArrangedSubview(subtitleLabel)
    return stackView
  }()
  
  private lazy var mainLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18.0)
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()
  
  private lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 14.0)
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    baseImageView.image = nil
  }
  
  override init(frame _: CGRect) {
    super.init(frame: .zero)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateUI(with viewModel: GridItemCellViewModel) {
    mainLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
  }
  
  func updateImage(with data: Data) {
    baseImageView.image = UIImage(data: data)
  }

  private func setupUI() {
    contentView.backgroundColor = .lightGray
    
    contentView.addSubview(baseImageView)
    NSLayoutConstraint.activate(
      [
        baseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        baseImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        baseImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        baseImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ]
    )
    
    contentView.addSubview(baseVStackView)
    NSLayoutConstraint.activate(
      [
        baseVStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4.0),
        baseVStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4.0),
        baseVStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
        baseVStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
      ]
    )
  }
}
