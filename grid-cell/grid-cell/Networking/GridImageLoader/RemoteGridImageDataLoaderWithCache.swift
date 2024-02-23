//
//  RemoteGridImageDataLoaderWithCache.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

final class RemoteGridImageDataLoaderWithCache: GridImageDataLoader {
  let remoteLoader: GridImageDataLoader
  let cache: GridImageDataCache
  
  init(remoteLoader: GridImageDataLoader, cache: GridImageDataCache) {
    self.remoteLoader = remoteLoader
    self.cache = cache
  }
  
  func loadImageData(from url: URL, completion: @escaping (GridImageDataLoader.Result) -> Void) {
    remoteLoader.loadImageData(from: url) { [weak self] result in
      switch result {
      case let .success(data):
        completion(.success(data))
        do {
          try self?.cache.save(data, for: url)
        } catch {
          completion(.failure(error))
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
