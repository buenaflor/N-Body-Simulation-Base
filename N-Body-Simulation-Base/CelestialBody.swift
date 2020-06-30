//
//  CelestialBody.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 26.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class CelestialBody {
  private var position: Vector2D
  private var velocity: Vector2D
  private var force: Vector2D
  private var mass: Double
  private var color: NSColor
  
  init(position: Vector2D, velocity: Vector2D, mass: Double, color: NSColor) {
    self.position = position
    self.velocity = velocity
    self.mass = mass
    self.color = color
    self.force = Vector2D()
  }
  
  convenience init(posX: Double, posY: Double, velX: Double, velY: Double, mass: Double, color: NSColor) {
    self.init(position: Vector2D(x: posX, y: posY),
              velocity: Vector2D(x: velX, y: velY),
              mass: mass,
              color: color)
  }
}

extension CelestialBody: Equatable {
  static func ==(lhs: CelestialBody, rhs: CelestialBody) -> Bool {
    return lhs.position == rhs.position && lhs.mass == rhs.mass && lhs.velocity == rhs.velocity && lhs.force == rhs.force
  }
}
