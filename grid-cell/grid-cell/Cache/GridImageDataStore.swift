//
//  GridImageDataStore.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

protocol GridImageDataStore {
  func insert(_ data: Data, for url: URL) throws
  func retrieve(from url: URL) throws -> Data?
}

enum FileStore {
  static let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

class GridImageFileStore: GridImageDataStore {
  let storeURL: URL
  
  init(storeURL: URL = FileStore.storeURL) {
    self.storeURL = storeURL
  }
  
  func insert(_ data: Data, for url: URL) throws {
    try data.write(to: composeStorePath(with: url))
  }
  
  func retrieve(from url: URL) throws -> Data? {
    try Data(contentsOf: composeStorePath(with: url))
  }
  
  private func composeStorePath(with url: URL) -> URL {
    storeURL.appendingPathComponent(url.lastPathComponent)
  }
}
