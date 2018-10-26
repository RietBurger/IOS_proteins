//
//  SceneViewController.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/25.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var SceneView: SCNView!
    //var SceneView:SCNView!
    var Scene:SCNScene!
    var SceneCamera:SCNNode!
    var CreationTime:TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initScene()
        initCamera()
//        createTarget()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        //SceneView = self.view as! SCNView
        SceneView.allowsCameraControl = true
        SceneView.autoenablesDefaultLighting = true
        
        SceneView.delegate = self // remove
    }
    
    func initScene() {
        Scene = SCNScene()
        SceneView.scene = Scene
        
        SceneView.isPlaying = true
    }
    
    func initCamera() {
        SceneCamera = SCNNode()
        SceneCamera.camera = SCNCamera()
        
        SceneCamera.position = SCNVector3(x: 0, y:5, z: 10)
        
        Scene.rootNode.addChildNode(SceneCamera)
    }
    
    func createTarget() {
        let geometry:SCNGeometry = SCNPyramid(width: 1, height: 1, length: 1)
        
        let randomColour = arc4random_uniform(2) == 0 ? UIColor.green : UIColor.red
        
        geometry.materials.first?.diffuse.contents = randomColour
        
        
        let geometryNode = SCNNode(geometry: geometry)
        //remove
        if randomColour == UIColor.green {
            geometryNode.name = "friend"
        }
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        Scene.rootNode.addChildNode(geometryNode)
        
        let randonPos: Float = arc4random_uniform(2) == 0 ? -1.0 : 1.0
        
        let position = SCNVector3(x: randonPos, y: 15, z: 0)
        
        geometryNode.physicsBody?.applyForce(position, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > CreationTime {
            createTarget()
            CreationTime = time + 0.6
        }
        cleanup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: SceneView)
        
        let hitTest = SceneView.hitTest(location, options: nil)
        
        if let hitObject = hitTest.first {
            let node = hitObject.node
            if node.name == "friend" {
                self.SceneView.backgroundColor = UIColor.blue
            }
            //add node name to label here
        }
    }
    
    func cleanup() { //remove
        for node in Scene.rootNode.childNodes {
            if node.presentation.position.y < -2 {
                node.removeFromParentNode()
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true;
    }
    
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
