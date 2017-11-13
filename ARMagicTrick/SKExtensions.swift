//
//  SCNNodeExtension.swift
//  ARMagicTrick
//
//  Created by Joshua Newnham on 13/11/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension SCNVector3{
    
    static func + (left: SCNVector3, right : SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func - (left: SCNVector3, right : SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
}

extension SCNNode {
    
    func boundingBoxContains(_ node: SCNNode) -> Bool {
        return self.boundingBoxContains(node.presentation.boundingSphere.center)
    }
    
    func boundingBoxContains(_ point: SCNVector3) -> Bool{
        let (min, max) = self.presentation.boundingBox
        
        return
            point.x >= min.x  &&
                point.y >= min.y  &&
                point.z >= min.z  &&
                
                point.x < max.x  &&
                point.y < max.y  &&
                point.z < max.z
    }    
}
