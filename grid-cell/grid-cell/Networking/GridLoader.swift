//
//  GridLoader.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/22.
//

import Foundation

protocol GridLoader {
  typealias Result = Swift.Result<([GridItem]), Error>

  func load(completion: @escaping (Result) -> Void)
}
