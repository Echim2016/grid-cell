//
//  HomeViewController.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import UIKit

class HomeViewController: UIViewController {
  
  private lazy var mainButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(red: 124.0/255.0, green: 76.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Next Page", for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    setupUI()
  }
  
  private func setupUI() {
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
}
