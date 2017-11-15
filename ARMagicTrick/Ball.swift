//
//  Ball.swift
//  ARMagicTrick
//
//  Created by Joshua Newnham on 13/11/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Ball : SCNNode{
    
    var radius : CGFloat = 0.03
    var mass : CGFloat = 1.0
    var friction : CGFloat = 0.5
    var rollingFriction : CGFloat = 0.6
    var damping : CGFloat = 0.3
    var angularDamping : CGFloat = 0.5
    
    override init() {
        super.init()
        
        self.initGeometry()
        self.initPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func initGeometry(){
        // create geometry
        let ball = SCNSphere(radius: radius)
        // create and assign material
        let ballMaterial = SCNMaterial()
        ballMaterial.diffuse.contents = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        ballMaterial.specular.contents = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        ball.materials = [ballMaterial]
        
        self.geometry = ball
    }
    
    private func initPhysics(){
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.mass = mass
        physicsBody.friction = friction
        physicsBody.rollingFriction = rollingFriction
        physicsBody.damping = damping
        physicsBody.angularDamping = angularDamping
        self.physicsBody = physicsBody
    }
}

