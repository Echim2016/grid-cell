//
//  GridViewController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import RxSwift
import UIKit

final class GridItemCellRenderController {
  private var cell: GridItemCell? = nil
  private let viewModel: GridItemCellViewModel
  
  init(viewModel: GridItemCellViewModel) {
    self.viewModel = viewModel
  }
  
  func setupCell(with cell: GridItemCell) {
    self.cell = cell
  }
  
  func preload() {
    viewModel.loadImage { [weak self] result in
      switch result {
      case let .success(data):
        self?.cell?.updateImage(with: data)
      case .failure:
        break
      }
    }
    cell?.updateUI(with: viewModel)
  }
  
  func cancelLoad() {
    viewModel.cancelLoadImageTask()
    cell = nil
  }
}

final class GridViewModel {
  let gridLoader: GridLoader
  let imageLoader: GridImageDataLoader
  let disposeBag = DisposeBag()
  let items = BehaviorSubject<[GridItemCellRenderController]>(value: [])
  
  init(gridLoader: GridLoader, imageLoader: GridImageDataLoader) {
    self.gridLoader = gridLoader
    self.imageLoader = imageLoader
  }

  func loadItems() {
    gridLoader.load { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(gridItems):
        let controllers = gridItems.map {
          GridItemCellRenderController(viewModel: GridItemCellViewModel(item: $0, imageLoader: self.imageLoader))
        }
        self.items.onNext(controllers)
      case let .failure(error):
        print(error)
      }
    }
  }
  
  func preloadItem(at index: Int, cell: GridItemCell) {
    guard let controller = getController(index: index) else { return }
    controller.setupCell(with: cell)
    controller.preload()
  }
  
  func cancelItemTask(at index: Int) {
    guard let controller = getController(index: index) else { return }
    controller.cancelLoad()
  }
  
  private func getController(index: Int) -> GridItemCellRenderController? {
    do {
      let controller = try items.value()[index]
      return controller
    } catch {
      return nil
    }
  }
}

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
