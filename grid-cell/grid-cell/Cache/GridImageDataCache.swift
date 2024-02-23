//
//  GridImageDataCache.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

protocol GridImageDataCache {
  func save(_ data: Data, for url: URL) throws
}
