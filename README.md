# MPSimply

This SPM library helps you set up a Metal GPU device, reserve buffers of the right size, and move data into and out of these buffers.

## Usage

```swift
import MPSimply

let devMgr = DeviceManager()!
let myArray = [1, 2, 3, 4]

let encoder = devMgr.commandBuffer.makeComputeCommandEncoder()!

let buf: MTLBuffer = devMgr.intoBuffer(myArray, index: 0, computeEncoder: encoder)!

// ... do something cool, eg make MPSNDArray from buf, put it on an MPSGraph tensor...
```
