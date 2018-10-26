//
//  SceneViewController.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/25.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController {

    var SceneView:SCNView!
    var Scene:SCNScene!
    var SceneCamera:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initScene()
        initCamera()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        SceneView = self.view as! SCNView
        SceneView.allowsCameraControl = true
        SceneView.autoenablesDefaultLighting = true
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
