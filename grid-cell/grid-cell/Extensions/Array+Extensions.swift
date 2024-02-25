//
//  Array+Extensions.swift
//  grid-cell
//
//  Created by Yi-Chin Hsu on 2024/2/25.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    guard indices.contains(index) else {
      return nil
    }
    return self[index]
  }
}
