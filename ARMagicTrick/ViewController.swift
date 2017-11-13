//
//  ViewController.swift
//  ARMagicTrick
//
//  Created by Joshua Newnham on 17/10/2017.
//  Copyright © 2017 Josh Newnham. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var ballsContainer : SCNNode?
    
    var magicHat : MagicHat?{
        get{
            return sceneView.scene.rootNode.childNode(withName: "MagicHat", recursively: true) as? MagicHat
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // create node to hold our balls
        ballsContainer = SCNNode()
        sceneView.scene.rootNode.addChildNode(ballsContainer!)
        
        // create gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(ViewController.onViewTapped(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        createButton()
    }
    
    /**
     
    */
    private func createButton(){
        
        let buttonBottomPadding : CGFloat = 20
        let buttonFontSize : CGFloat = 30
        let buttonSize = CGSize(width: 200, height: 100)
        
        let button : UIButton = UIButton(type: .roundedRect)
        button.frame = CGRect(
            x: (self.view.bounds.size.width - buttonSize.width)/2,
            y: self.view.bounds.size.height - (buttonSize.height + buttonBottomPadding),
            width: 200,
            height: 80)
        
        self.view.addSubview(button)
        
        button.titleLabel?.font =  UIFont.systemFont(ofSize: buttonFontSize)
        button.setTitle("Magic!", for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self,
                         action: #selector(ViewController.onMagicButtonTapped(_:)),
                         for: .touchUpInside)
        
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: buttonBottomPadding)
        
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: buttonSize.height)
        
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonSize.width)
        
        //NSLayoutConstraint.activate([heightConstraint, bottomConstraint])
        
        button.addConstraint(heightConstraint)
        button.addConstraint(widthConstraint)
        self.view.addConstraint(bottomConstraint)
        self.view.addConstraint(horizontalConstraint)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """)
        }
        
        /*
         Start the view's AR session with a configuration that uses the rear camera,
         device position and orientation tracking, and plane detection.
         */
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        /*
         Prevent the screen from being dimmed after a while as users will likely
         have long periods of interaction without touching the screen or buttons.
         */
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        //sceneView.showsStatistics = true
        
        //self.sceneView.debugOptions = [.showConstraints, .showPhysicsShapes, ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.automaticallyUpdatesLighting = true
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
    
    func positionMagicHat(_ position : SCNVector3, node : SCNNode){
        // Find magichat
        let magichat = MagicHat()
        magichat.position = position
        node.addChildNode(magichat)
        magichat.isHidden = false
    }
    
    /**
     returns: direction, position
    **/
    func getCamerasDirectionAndPosition() -> (SCNVector3, SCNVector3) {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
}

// MARK: - Interface Builder Actions

extension ViewController{
    
    @IBAction func onMagicButtonTapped(_ sender: UIButton) {
        /*
         Make balls within the hat disappear!
        */
        
        guard let magicHat = self.magicHat else{ return }
        
//        let (min, max) = magicHat.boundingBox
//        let size = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
//        print("MH size \(size)")
        
        guard let ballsContainer = self.ballsContainer else{ return }
        
        for i in (0..<ballsContainer.childNodes.count).reversed(){
            let ball = ballsContainer.childNodes[i]
            
            // check if the balls center is within the bounds of the hat
            if magicHat.boundingBoxContains(ball){
                
                // ball within bounds, remove ball
                ball.removeFromParentNode()
            }
        }
    }
    
    @IBAction func onViewTapped(_ sender: UITapGestureRecognizer) {
        /*
         Create the ball (i.e. an SCNSphere), either programmatically or using the SceneKit scene editor, and have the user be able to throw that ball by tapping a button on the UI.
         
         Throwing a ball can be done in 3 steps: (1) position the ball in front of the camera using the camera's transform, (2) add a SCNPhysicsBody to the ball, and (3) apply a force to the SCNPhysicsBody.
         */
        
        // get position of camera
        let (cameraDirection, cameraPosition) = getCamerasDirectionAndPosition()
        
        // 1. create ball
        let ball = Ball()
        
        // 2. position balls node with cameras transform
        ball.position = cameraPosition
        
        // 3. add force (push out from the screen)
        let force : Float = 2.0
        let ballForce = SCNVector3(cameraDirection.x * force, cameraDirection.y * force, cameraDirection.z * force)
        if let ballPhysicsBody = ball.physicsBody{
            ballPhysicsBody.applyForce(ballForce, asImpulse: true)
        }
        
        // Add ball node to ballsContainer
        ballsContainer?.addChildNode(ball)
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController : ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Create an SNCPlane on the ARPlane
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        plane.materials = [planeMaterial]
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        planeNode.physicsBody = physicsBody
        
        node.addChildNode(planeNode)
        
        positionMagicHat(SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z), node: node)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         Plane estimation may extend the size of the plane, or combine previously detected
         planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
         corresponding node for one plane, then calls this method to update the size of
         the remaining plane.
         */
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    }
}

// MARK: - ARSessionObserver

extension ViewController : ARSessionObserver{
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session failed: \(error.localizedDescription)")
        resetTracking()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Session was interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Session interruption ended")
        resetTracking()
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - ARSessionDelegate

extension ViewController : ARSessionDelegate{
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move the device around to detect horizontal surfaces."
            
        case .normal:
            // No feedback needed when tracking is normal and planes are visible.
            message = ""
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        }
        
        print(message)
    }
}
