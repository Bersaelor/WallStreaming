//
//  VirtualWall.swift
//  WallStreaming
//
//  Created by Konrad Feiler on 15.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import ARKit
import UIKit
import SceneKit

class VirtualWall: SCNNode {
    
    private let anchor: ARPlaneAnchor
    private let plane: SCNPlane
    private let planeNode: SCNNode
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        self.plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        self.planeNode = SCNNode(geometry: self.plane)
        
        super.init()
        
        plane.firstMaterial = VirtualWall.makePlaneMaterial()
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        
        updateMaterialDiffuseScale()
        
        self.addChildNode(planeNode)
    }
    
    private static func makePlaneMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white.withAlphaComponent(0.50)
        return material
    }
    
    /// This method will update the plane when it changes.
    ///
    /// - Parameter anchor: the ARPlaneAnchor
    func update(anchor: ARPlaneAnchor) {
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        // update the material representation for this plane
        updateMaterialDiffuseScale()
    }
    

    /// Scale the diffuse component of the material
    func updateMaterialDiffuseScale() {
        guard let material = plane.materials.first else { return }
        
        let width = Float(self.plane.width)
        let height = Float(self.plane.height)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
