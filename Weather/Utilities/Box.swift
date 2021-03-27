//
//  Box.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation

//Borrowed box implementation from RWenderlich for binding VM and V
final class Box<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
    
  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
