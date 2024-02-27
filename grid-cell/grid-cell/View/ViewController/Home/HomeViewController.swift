//
//  HomeViewController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
  let viewModel: HomeViewModel
  let coordinator: MainCoordinator?

  lazy var mainButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(red: 124.0 / 255.0, green: 76.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    button.setTitleColor(.white, for: .normal)
    button.setTitle(viewModel.buttonTitle, for: .normal)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBindings()
  }

  init(viewModel: HomeViewModel, coordinator: MainCoordinator?) {
    self.viewModel = viewModel
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    title = viewModel.navigationBarTitle
    view.backgroundColor = .white

    view.addSubview(mainButton)
    NSLayoutConstraint.activate(
      [
        mainButton.heightAnchor.constraint(equalToConstant: 48.0),
        mainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48.0),
        mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
        mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
      ]
    )
  }

  private func setupBindings() {
    mainButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.navigateToGridPage()
      }
      .disposed(by: viewModel.disposeBag)
  }
}
