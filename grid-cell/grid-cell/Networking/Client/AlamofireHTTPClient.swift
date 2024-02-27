//
//  AlamofireHTTPClient.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import Alamofire
import Foundation

final class AlamofireHTTPClient: HTTPClient {
  func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> CancellableTask? {
    let task = AF.request(url)
      .response { response in
        if let error = response.error {
          completion(.failure(error))
        } else if let data = response.data {
          completion(.success(data))
        }
      }
    task.resume()
    return task
  }
}

extension DataRequest: CancellableTask {
  public func cancel() {
    self.task?.cancel()
  }
}
