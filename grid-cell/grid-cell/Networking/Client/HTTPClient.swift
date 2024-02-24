//
//  HTTPClient.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import Foundation

protocol CancellableTask {
  func cancel()
}

protocol HTTPClient {
  typealias Result = Swift.Result<(Data), Error>

  func get(from url: URL, completion: @escaping (Result) -> Void) -> CancellableTask?
}
