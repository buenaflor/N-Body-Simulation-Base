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
  private var children: [Quadtree] = []
  
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
  
  // Returns true if the body is in the bounds of the bounding box
  func contains(body: CelestialBody) -> Bool {
    return body.inside(boundingBox: self.boundingBox)
  }
  
  func insert(body: CelestialBody) {
    guard contains(body: body) else {
      return
    }
    if isLeaf {
      if (self.body == nil) {
        self.pseudoBody = body;
        self.body = body;
        return;
      } else {
        // We're at a leaf, but there is a body
        // Remove the body and split this node so that it has 4 children
        // Then insert the old and new node into the correct quadrant
        
        // Save the old node for re-insertion later
        let oldBody = self.body!
        self.body = nil;
        
        // Set pseudo body
        self.pseudoBody = body.createPseudobody(with: oldBody);
        
        // Compute new bounding boxes for children
        self.computeNewQuadtrees()
        
        // Re-insert the old point, and insert this new node
        self.insertNode(body: oldBody)
        self.insertNode(body: body)
      }
    } else {
      // Set pseudo body
      self.pseudoBody = body.createPseudobody(with: self.pseudoBody!);
      
      // Since this is not a leaf, there are still subtrees
      // We need to insert the node at the correct quadrant position
      self.insertNode(body: body)
    }
  }
  
  private func insertNode(body: CelestialBody) {
    let pos = body.quadPosition(in: boundingBox)
    if (pos == 0) { SW?.insert(body: body) }
    if (pos == 1) { NW?.insert(body: body) }
    if (pos == 2) { SE?.insert(body: body) }
    if (pos == 3) { NE?.insert(body: body) }
  }
  
  private func computeNewQuadtrees() {
    SW = Quadtree(boundingBox: boundingBox.SW())
    NW = Quadtree(boundingBox: boundingBox.NW())
    SE = Quadtree(boundingBox: boundingBox.SE())
    NE = Quadtree(boundingBox: boundingBox.NE())
  }
  
  // Updates the force applied on the given body b based on the Barnes Hut Algorithm
  // It approximates the force calculation based on the pseudo body, if the conditions are met
  // In the worst case, the algorithm goes to the leafs to calculate forces directly with the body
  func updateForce(body: CelestialBody) {
    if isLeaf {
      if (self.body != body && self.body != nil) {
        body.calculateForce(body: self.body!)
      }
    } else if ((self.boundingBox.halfLength * 2) / (body.distance(to: self.pseudoBody!)) < 1) {
      body.calculateForce(body: self.pseudoBody!);
    } else {
      if SW != nil { SW?.updateForce(body: body) }
      if NW != nil { NW?.updateForce(body: body) }
      if SE != nil { SE?.updateForce(body: body) }
      if NE != nil { NE?.updateForce(body: body) }
    }
  }
  
  func drawLeafQuads() {
    if isLeaf && body != nil {
      boundingBox.drawBorder()
    }
    if SW != nil { SW?.drawLeafQuads() }
    if NW != nil { NW?.drawLeafQuads() }
    if SE != nil { SE?.drawLeafQuads() }
    if NE != nil { NE?.drawLeafQuads() }
  }
  
  func drawAllQuads() {
    boundingBox.drawBorder()
    if SW != nil { SW?.drawAllQuads() }
    if NW != nil { NW?.drawAllQuads() }
    if SE != nil { SE?.drawAllQuads() }
    if NE != nil { NE?.drawAllQuads() }
  }
}
