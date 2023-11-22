//
//  DAGraph.swift
//
//
//  Created by Eric Canton on 11/22/23.
//

import Foundation
import MetalPerformanceShadersGraph

@available(macOS 11.0, *)
class DAGraph: MPSGraph {
  var deviceManager: DeviceManager?
  
  init(withManager: DeviceManager?) {
    deviceManager = withManager ?? DeviceManager()
  }
  
  
}
