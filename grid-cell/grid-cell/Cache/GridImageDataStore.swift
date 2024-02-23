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
