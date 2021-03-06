//
//  ViewController.swift
//  AR Rough Sketch
//
//  Created by David Ilenwabor on 02/01/2019.
//  Copyright © 2019 David Ilenwabor. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var drawbtn: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        //sceneView.scene = SCNScene()
        sceneView.delegate = self
        //sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //configuration.worldAlignment = .gravity
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let frame = self.sceneView.pointOfView else{
            return
        }
        let transform = frame.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = orientation + location
        DispatchQueue.main.async {
            if self.drawbtn.isHighlighted{
                print("Button pressed to draw")
                let sphere = SCNSphere(radius: 0.03)
                let sphereNode = SCNNode(geometry: sphere)
                
                sphereNode.position = position
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                
            } else{
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                pointer.position = position
                pointer.name = "Pointer"
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "Pointer"{
                        node.removeFromParentNode()
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
    
    
//    func calculateCameraPosition(renderer : SCNSceneRenderer) -> SCNVector3{
//
//        return orientation + location
//    }
    
   


}

func +(left : SCNVector3, right : SCNVector3)->SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

