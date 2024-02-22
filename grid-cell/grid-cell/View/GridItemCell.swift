//
//  GridItemCell.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import UIKit

final class GridItemCellViewModel {
  let title: String
  let subtitle: String
  let imageUrl: URL?
  
  init(item: GridItem) {
    self.title = "\(item.id)"
    self.subtitle = item.title
    self.imageUrl = item.thumbnailUrl
  }
}

final class GridItemCell: UICollectionViewCell {
  
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
  
  var viewModel: GridItemCellViewModel? {
    didSet {
      updateUI()
    }
  }
  
  override init(frame _: CGRect) {
    super.init(frame: .zero)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateUI() {
    mainLabel.text = viewModel?.title
    subtitleLabel.text = viewModel?.subtitle
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
