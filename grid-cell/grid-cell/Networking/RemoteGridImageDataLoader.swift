//
//  RemoteGridImageDataLoader.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/23.
//

import Foundation

final class RemoteGridImageDataLoader: GridImageDataLoader {
  let client: HTTPClient
  
  init(client: HTTPClient) {
    self.client = client
  }
  
  func loadImageData(from url: URL, completion: @escaping (GridImageDataLoader.Result) -> Void) {
    client.get(from: url, completion: completion)
  }
}
