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
  
  func draw() {
    position.drawPoint(with: color)
  }
  
  /// Returns true if the body is in the bounds of the bounding box
  func inside(boundingBox: BoundingBox2D) -> Bool {
    return boundingBox.contains(position: self.position);
  }
  
  /// Calculate the force applied on this body by body b and add it to the force vector
  func calculateForce(body: CelestialBody) {
    var direction = body.position.minus(vector: self.position)
    let r = direction.length
    direction.normalize();
    let F = Simulation.G * body.mass * self.mass / (r * r)
    self.force = direction.times(by: F).plus(vector: force)
  }

  /// Resets the force to 0 because we need to calculate the force fresh when the body moved
  func resetForces() {
    self.force.reset()
  }
  
  // delta t is the time quantum used to accelerate or deccelerate the simulation
  // This is based on the "leapfrog" method
  func update(dt: Double) {
    self.velocity = self.force.times(by: dt / self.mass).plus(vector: self.velocity);   // vx += dt * fx / mass...
    self.position = self.velocity.times(by: dt).plus(vector: self.position)              // vx += dt * vx...
  }
  
  /// Returns the euclidean distance from this body to body b
  func distance(to body: CelestialBody) -> Double {
    return self.position.distance(to: body.position);
  }
  
  /// Returns the quad position index of the current body in a bounding box
  func quadPosition(in boundingBox: BoundingBox2D) -> Int {
    return boundingBox.quadPosition(position)
  }
  
  func createPseudobody(with body: CelestialBody) -> CelestialBody {
    let combinedMass = self.mass + body.mass;
    let combinedPosition = self.position.times(by: self.mass).plus(vector: body.position.times(by: body.mass)).divided(by: combinedMass)
    let combinedBody = CelestialBody(position: combinedPosition, velocity: Vector2D(), mass: combinedMass, color: .white)
    return combinedBody;
  }
  
}

extension CelestialBody: Equatable {
  static func ==(lhs: CelestialBody, rhs: CelestialBody) -> Bool {
    return lhs.position == rhs.position && lhs.mass == rhs.mass
  }
}
