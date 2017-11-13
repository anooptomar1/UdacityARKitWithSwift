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
        
        magichat.position = SCNVector3(0, 0, 0)
        
        self.addChildNode(magichat)
    }
    
}
