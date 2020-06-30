//
//  DrawSpace.swift
//  N-Body-Simulation
//
//  Created by Giancarlo Buenaflor on 27.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class DrawSpace {
  
  var xmin: Double = 0
  var xmax: Double = 1
  var ymin: Double = 0
  var ymax: Double = 1
  var width: CGFloat = 0
  var height: CGFloat = 0
  var squareLineWidth: CGFloat = 0.5
  var lineWidth: CGFloat = 1
  var pointSize: Double = 1.2

  static let shared = DrawSpace()
  private init() { }
  
  /// Returns scaled width
  private func factorX(_ w: Double) -> Double { return w * Double(width)  / abs(xmax - xmin)  }
  
  /// Returns scaled height
  private func factorY(_ h: Double) -> Double { return h * Double(height) / abs(ymax - ymin);  }
  
  /// Returns the scaled x value
  private func scaleX(_ x: Double) -> Double { return Double(width)  * (x - xmin) / (xmax - xmin) }
  
  /// Returns the scaled y value
  private func scaleY(_ y: Double) -> Double { return Double(height) * (ymax + y) / (ymax - ymin) }
  
  /// Sets up the width and height for the drawing space
  func setRect(rect: NSRect) {
    width = rect.width
    height = rect.height
  }
  
  /// Sets the x scale for the drawing space
  func setXscale(min: Double, max: Double) {
    assert(min < max)
    xmin = min
    xmax = max
  }
  
  /// Sets the y scale for the drawing space
  func setYscale(min: Double, max: Double) {
    assert(min < max)
    ymin = min
    ymax = max
  }
  
  /// Draws a point at the coordinates (x, y)
  func point(x: Double, y: Double) {
    let xs = scaleX(x)
    let ys = scaleY(y)
    let dot = NSBezierPath(ovalIn: CGRect(x: xs, y: ys, width: pointSize, height: pointSize))
    dot.fill()
  }
  
  /// Draws a square with the coordinates (x, y) at its center
  func square(x: Double, y: Double, halfLength: Double) {
    let xs = scaleX(x)
    let ys = scaleY(y)
    let ws = factorX(2 * halfLength);
    let hs = factorY(2 * halfLength);
    let quad = NSBezierPath(rect: NSRect(x: xs, y: ys, width: ws, height: hs))
    quad.lineWidth = squareLineWidth
    quad.stroke()
  }
  
  /// Draws a line from (x1, y1) to (x2, y2)
  func line(x1: Double, y1: Double, x2: Double, y2: Double) {
    let xs1 = scaleX(x1)
    let ys1 = scaleY(y1)
    let xs2 = scaleX(x1)
    let ys2 = scaleY(y1)
    let path = NSBezierPath()
    path.move(to: NSPoint(x: xs1, y: ys1))
    path.line(to: NSPoint(x: xs2, y: ys2))
    path.lineWidth = lineWidth
    path.stroke()
  }
}
