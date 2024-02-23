//
//  GridImageLoaderWithFallbackComposite.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

final class GridImageLoaderWithFallbackComposite: GridImageDataLoader {
  let primaryLoader: GridImageDataLoader
  let fallbackLoader: GridImageDataLoader
  
  init(primaryLoader: GridImageDataLoader, fallbackLoader: GridImageDataLoader) {
    self.primaryLoader = primaryLoader
    self.fallbackLoader = fallbackLoader
  }
  
  func loadImageData(from url: URL, completion: @escaping (GridImageDataLoader.Result) -> Void) -> CancellableTask? {
    primaryLoader.loadImageData(from: url) { [weak self] result in
      switch result {
      case let .success(data):
        completion(.success(data))
      case .failure:
        self?.fallbackLoader.loadImageData(from: url, completion: completion)
      }
    }
  }
}
