//
//  Quadtree.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 27.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Foundation

class Quadtree {
  private var boundingBox: BoundingBox2D
  private var body: CelestialBody?
  private var pseudoBody: CelestialBody?
  
  private var SW: Quadtree?
  private var NW: Quadtree?
  private var SE: Quadtree?
  private var NE: Quadtree?

  private var isLeaf: Bool {
    return SW == nil
  }
  
  init(boundingBox: BoundingBox2D) {
    self.boundingBox = boundingBox
  }
}
