//
//  MagicHat.swift
//  ARMagicTrick
//
//  Created by Joshua Newnham on 13/11/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MagicHat : SCNNode{
    
    var tubeNode : SCNNode?
    
    override init() {
        super.init()
        
        guard let scene = SCNScene(named: "magichat.scn", inDirectory: "art.scnassets")
            else {
                fatalError("Unable to find scene")
        }
        
        self.name = "MagicHat"
        
        initFromScene(scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initFromScene(_ scene: SCNScene){
        guard let magichat = scene.rootNode.childNode(withName: "magichat", recursively: true) else{
            fatalError("Failed to find child with the name magichat")
        }
        
        for childNode in magichat.childNodes{
            if let name = childNode.name{
                if name == "tube"{
                    tubeNode = childNode
                    break
                }
            }
        }
        
        magichat.position = SCNVector3(0, 0, 0)
        
        self.addChildNode(magichat)
    }
    
    func boundingBoxContains(_ node: SCNNode) -> Bool {
        return self.boundingBoxContains(node.presentation.worldPosition)
    }
    
    func boundingBoxContains(_ point: SCNVector3) -> Bool{
        let node = self.tubeNode ?? self
        var (min, max) = node.presentation.boundingBox
        
        let size = max - min
        min = SCNVector3(self.worldPosition.x - size.x/2, self.worldPosition.y, self.worldPosition.z - size.z/2)
        max = SCNVector3(self.worldPosition.x + size.x/2, self.worldPosition.y + size.y, self.worldPosition.z + size.z/2)
        
        return
            point.x >= min.x  &&
                point.y >= min.y  &&
                point.z >= min.z  &&
                
                point.x < max.x  &&
                point.y < max.y  &&
                point.z < max.z
    }    
}
