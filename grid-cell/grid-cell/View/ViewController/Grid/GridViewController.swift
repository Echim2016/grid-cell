//
//  GridViewController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import RxSwift
import UIKit

final class GridViewController: UIViewController {
  let viewModel: GridViewModel

  private lazy var collectionView = {
    let layout = UICollectionViewFlowLayout()
    let itemWidth = (view.bounds.width - 3) / 4.0
    layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(GridItemCell.self, forCellWithReuseIdentifier: "\(GridItemCell.self)")
    return collectionView
  }()

  init(viewModel: GridViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBindings()
    loadItems()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    view.addSubview(collectionView)
    collectionView.frame = view.bounds
  }

  private func setupBindings() {
    viewModel
      .items
      .bind(
        to: collectionView.rx.items(
          cellIdentifier: "\(GridItemCell.self)",
          cellType: GridItemCell.self
        )
      ) { index, controller, cell in
        controller.setupCell(with: cell)
        controller.preload()
      }
      .disposed(by: viewModel.disposeBag)
    
    collectionView.rx
      .didEndDisplayingCell
      .bind { [weak self] _, indexPath in
        guard let self else { return }
        self.viewModel.cancelItemTask(at: indexPath.row)
      }
      .disposed(by: viewModel.disposeBag)
  }

  private func loadItems() {
    viewModel.loadItems()
  }
}
