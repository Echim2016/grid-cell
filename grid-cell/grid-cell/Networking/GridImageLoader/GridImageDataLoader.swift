//
//  GridImageDataLoader.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

protocol GridImageDataLoader {
  typealias Result = Swift.Result<(Data), Error>

  func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> CancellableTask?
}
