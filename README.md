# WallStreaming

Small example demonstrating how to play a video on a wall using [ARKit](https://developer.apple.com/arkit/).

 ![Video on the wall](exampleVideo.gif)

This became possible since iOS 11.3 / ARKit "1.5" adding the `.vertical` option for the `.planeDetection` parameter of `ARWorldTrackingConfiguration`.

The only "trick" was to use `SpriteKit`'s `SKVideoNode` in an standard `SpriteKit` `SKScene`:

```swift
    let playerItem = AVPlayerItem(url: streamURL)
    let player = AVPlayer(playerItem: playerItem)
    let videoNode = SKVideoNode(avPlayer: player)
    scene.addChild(videoNode)
```

and setting the texture of the virtual wall added where `ARKit` detects the vertical surface:

```swift
    guard let material = plane.materials.first else { return }
    material.diffuse.contents = scene
```


