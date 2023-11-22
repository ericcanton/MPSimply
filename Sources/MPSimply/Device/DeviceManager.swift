//
//  DeviceManager.swift
//
//
//  Created by Eric Canton on 11/22/23.
//

import Foundation
import Metal

@available(macOS 10.15, *)
struct DeviceManager {
  let device: MTLDevice
  let commandQueue: MTLCommandQueue
  let commandBuffer: MTLCommandBuffer
  /// When using a DeviceManager with a direct metal library, it can be helpful to assign this variable.
  /// Add the `.metal` files to your project, then you can do something like:
  /// ```
  /// var mgr = DeviceManager()!
  /// mgr.library = try? mgr.device.makeDefaultLibrary(bundle: Bundle.module)
  /// ```
  var library: MTLLibrary?
  
  init?() {
    guard let device: MTLDevice = MTLCopyAllDevices().first,
          let commandQueue: MTLCommandQueue = device.makeCommandQueue(),
          let commandBuffer: MTLCommandBuffer = commandQueue.makeCommandBuffer()
    else {
      return nil
    }
    self.device = device
    self.commandQueue = commandQueue
    self.commandBuffer = commandBuffer
  }

  func intoBuffer<T>(array: inout [T],
                     index: Int,
                     computeEncoder: MTLComputeCommandEncoder,
                     options: MTLResourceOptions = MTLResourceOptions.storageModeShared) -> MTLBuffer? {
    let bufferSize = array.count  * MemoryLayout<T>.stride
    // TODO: figure out this error. Need some withUnsafeMutableRawPointer(to:) {...} thing?
    return array.withUnsafeMutableBytes { addr in
      guard let ptr = addr.baseAddress,
            let buffer = device.makeBuffer(bytesNoCopy: ptr, length: bufferSize, options: [options])
      else {
        return nil
      }
      computeEncoder.setBuffer(buffer, offset: 0, index: index)
      return buffer
    }
  }
  
  func makeBuffer<T>(count: Int, type: T.Type,
                     index: Int, computeEncoder: MTLComputeCommandEncoder,
                     options: MTLResourceOptions = MTLResourceOptions.storageModeShared) -> MTLBuffer? {
    
    let bufferSize = count * MemoryLayout<T>.stride
    guard let buf = device.makeBuffer(length: bufferSize, options: options) else {
      return nil
    }
    
    computeEncoder.setBuffer(buf, offset: 0, index: index)
    return buf
  }
}
