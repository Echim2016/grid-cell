//
//  GridViewController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import RxSwift
import UIKit

class GridViewModel {}

class GridViewController: UIViewController {
  let viewModel: GridViewModel

  private lazy var collectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  init(viewModel: GridViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.frame = view.bounds
  }
}
