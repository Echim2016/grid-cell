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

// MARK: - Load/Retrieve image data from local store
extension LocalGridImageDataLoader: GridImageDataLoader {
  enum LocalLoadError: Error {
    case failed
    case notFound
  }

  func loadImageData(from url: URL, completion: @escaping (GridImageDataLoader.Result) -> Void) {
    do {
      if let imageData = try store.retrieve(from: url) {
        completion(.success(imageData))
      } else {
        completion(.failure(LocalLoadError.notFound))
      }
    } catch {
      completion(.failure(LocalLoadError.failed))
    }
  }
}

// MARK: - Cache/Save image data from local store
extension LocalGridImageDataLoader: GridImageDataCache {
  enum LocalSaveError: Error {
    case failed
  }
  
  func save(_ data: Data, for url: URL) throws {
    do {
      try store.insert(data, for: url)
    } catch {
      throw LocalSaveError.failed
    }
  }
}
