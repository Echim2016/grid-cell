//
//  LocalGridImageDataLoader.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

final class LocalGridImageDataLoader {
  let store: GridImageDataStore

  init(store: GridImageDataStore) {
    self.store = store
  }
}

extension LocalGridImageDataLoader: GridImageDataLoader {
  enum LocalLoadError: Error {
    case failed
    case notFound
  }

  func loadImageData(from url: URL, completion: @escaping (GridImageDataLoader.Result) -> Void) {
    do {
      if let imageData = try store.retrieve(from: url) {
        completion(.success(imageData))
      }
    } catch {
      completion(.failure(LocalLoadError.failed))
    }
    completion(.failure(LocalLoadError.notFound))
  }
}
