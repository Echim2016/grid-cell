//
//  RemoteGridLoader.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import Foundation

enum RemoteAPI {
  static let baseUrl = "https://jsonplaceholder.typicode.com"
}

final class RemoteGridLoader: GridLoader {
  enum Path: String {
    case photos = "/photos"
  }

  enum Error: Swift.Error {
    case decodeFailed
    case urlNotFound
  }

  private let url: URL?
  private let client: HTTPClient

  init(path: Path, client: HTTPClient) {
    url = URL(string: RemoteAPI.baseUrl + path.rawValue)
    self.client = client
  }

  func load(completion: @escaping (GridLoader.Result) -> Void) {
    guard let url else {
      completion(.failure(Error.urlNotFound))
      return
    }

    client.get(from: url) { result in
      switch result {
      case let .success(data):
        guard let items = try? JSONDecoder()
          .decode([GridItem].self, from: data)
        else {
          completion(.failure(Error.decodeFailed))
          return
        }
        completion(.success(items))

      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
