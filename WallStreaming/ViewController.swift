//
//  ViewController.swift
//  WallStreaming
//
//  Created by Konrad Feiler on 15.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var videoPlayer: VideoPlayer?
    var walls = [UUID: VirtualWall]()
    var streamStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // debug scene to see feature points and world's origin
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    private var streamingURL: URL {
        guard let urlFromSettings = UserDefaults.standard.string(forKey: "streaming_url"),
            let url = URL(string: urlFromSettings) else {
            return URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!
        }
        return url
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoPlayer = VideoPlayer(streamURL: streamingURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    private func startStream(in seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.videoPlayer?.play()
        }
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            let wall = VirtualWall(anchor: anchor)
            if let videoPlayer = videoPlayer {
                wall.setMaterial(content: videoPlayer.scene)
            }
            walls[anchor.identifier] = wall
            node.addChildNode(wall)
            
            if !streamStarted {
                streamStarted = true
                startStream(in: 2)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor, let wall = walls[anchor.identifier] {
            wall.update(anchor: anchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            walls.removeValue(forKey: anchor.identifier)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
