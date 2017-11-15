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
    
    static func / (left: SCNVector3, right : Float) -> SCNVector3 {
        return SCNVector3(left.x / right, left.y / right, left.z / right)
    }
    
    static func * (left: SCNVector3, right : Float) -> SCNVector3 {
        return SCNVector3(left.x * right, left.y * right, left.z * right)
    }
}
