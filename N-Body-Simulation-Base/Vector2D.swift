//
//  Vector2D.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 26.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

struct Vector2D {
  private(set) var x: Double
  private(set) var y: Double
    
  init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
  
  init() {
    self.init(x: 0, y: 0)
  }
  
  /// Returns this vector multiplied by a coefficient
  func divided(by coefficient: Double) -> Vector2D {
    return Vector2D(x: self.x / coefficient, y: self.y / coefficient)
  }
  
  /// Returns the this vector divided by a coefficient
  func times(by coefficient: Double) -> Vector2D {
    return Vector2D(x: self.x * coefficient, y: self.y * coefficient)
  }

  /// Returns the sum of this vector and -1*'vector'
  func minus(vector: Vector2D) -> Vector2D {
    return Vector2D(x: self.x - vector.x, y: self.y - vector.y)
  }
  
  /// Returns the sum of this vector and 'vector'
  func plus(vector: Vector2D) -> Vector2D {
    return Vector2D(x: self.x + vector.x, y: self.y + vector.y)
  }
  
  /// Normalizes the current vector so the length equals to one.
  /// The direction and orientation is not affected
  mutating func normalize() {
    let oLength = self.length
    self.x /= oLength
    self.y /= oLength
  }
  
  /// Sets the coordinates to their initial values of 0
  mutating func reset() {
    self.x = 0
    self.y = 0
  }
  
  /// Returns the euclidean distance to the specified 'vector'
  func distance(to vector: Vector2D) -> Double {
    let dx = self.x - vector.x
    let dy = self.y - vector.y
    return sqrt(dx * dx + dy * dy)
  }
  
  /// Returns the length of the vector
  var length: Double {
    return distance(to: Vector2D())
  }
  
  /// Draws a point with this vector at its center
  func drawPoint(with color: NSColor) {
    color.set()
    DrawSpace.shared.point(x: x, y: y)
  }
  
  /// Draws a square with this vector as its center
  func drawSquare(with color: NSColor, halfLength: Double) {
    color.set()
    DrawSpace.shared.square(x: x - halfLength, y: y - halfLength, halfLength: halfLength)
  }
  
  /// Returns true if x and y of this vector is greater or equal than x and y of the specified vector
  func greaterOrEqual(than vector: Vector2D) -> Bool {
    return (self.x >= vector.x && self.y >= vector.y)
  }
  
  /// Returns true if x and y of this vector is less or equal than x and y of the specified vector
  func lessOrEqual(than vector: Vector2D) -> Bool {
    return (self.x <= vector.x && self.y <= vector.y)
  }
}

extension Vector2D: Equatable {
  static func ==(lhs: Vector2D, rhs: Vector2D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }

}
