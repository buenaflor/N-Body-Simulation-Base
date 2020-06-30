//
//  Simulation.swift
//  UITesting
//
//  Created by Giancarlo Buenaflor on 27.06.20.
//  Copyright © 2020 Giancarlo Buenaflor. All rights reserved.
//

import Cocoa

class Simulation {

  // Gravitational constant
  static let G: Double = 6.6743e-11;

  // Radius of the universe
  var radius: Double = 0;

  // Increase this to accelerate simulation speed
  var dt: Double = 0.1;
  
  // Shared draw space to access drawing methods and set up the canvas
  let drawSpace = DrawSpace.shared
  
  // This view is responsible for drawing simulation
  var simulationView: SimulationView
  
  init(simulationView: SimulationView) {
    self.simulationView = simulationView
  }
    
  /// Starts the simulation loop
  func start() {
    let galaxyFiles: [String] = readGalaxies()
    for (index, element) in galaxyFiles.enumerated() {
      print("\(index): \(element)")
    }
    
    print("Which galaxy would you like to choose?")
    let choice = Int(readLine() ?? "0") ?? 0
    let galaxyFile = galaxyFiles[choice]
    let celestialBodies = createGalaxy(galaxyFile: galaxyFile)
    
    // The galaxy has been loaded and radius has been set
    // Now we can setup the draw space
    setupDrawSpace()
  }
  
  /// Setting up the draw space should be called after the galaxy file has been read and processed
  private func setupDrawSpace() {
    drawSpace.setRect(rect: simulationView.frame)
    drawSpace.setXscale(min: -radius, max: radius)
    drawSpace.setYscale(min: -radius, max: radius)
  }
}

extension Simulation {
  
  /// Searches for txt files and returns them (our galaxies)
  private func readGalaxies() -> [String] {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    do {
      let items = try fm.contentsOfDirectory(atPath: path)
      return items.filter { $0.suffix(4) == ".txt" }.map { String($0.prefix($0.count - 4)) }
    } catch {
      return []
    }
  }
  
  /// Reads a specific galaxy txt file and returns an array of celestial bodies
  private func createGalaxy(galaxyFile: String) -> [CelestialBody] {
    if let path = Bundle.main.path(forResource: galaxyFile, ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let myStrings = data.components(separatedBy: .newlines)
        
        // Radius of the universe
        radius = Double(myStrings[1]) ?? 0
                
        var celestialBodies: [CelestialBody] = []
        myStrings.enumerated().forEach { (index, element) in
          guard index > 1, !element.isEmpty else {
            return
          }
          let split = element.split(separator: " ")
          let px = Double(split[0]) ?? 0
          let py = Double(split[1]) ?? 0
          let vx = Double(split[2]) ?? 0
          let vy = Double(split[3]) ?? 0
          let mass = Double(split[4]) ?? 0
          let red = CGFloat(Double(split[5]) ?? 0)
          let green = CGFloat(Double(split[6]) ?? 0)
          let blue = CGFloat(Double(split[7]) ?? 0)
          let color = NSColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
          let body = CelestialBody(posX: px, posY: py, velX: vx, velY: vy, mass: mass, color: color)
          celestialBodies.append(body)
        }
        return celestialBodies
      } catch {
        return []
      }
    }
    return []
  }
}
