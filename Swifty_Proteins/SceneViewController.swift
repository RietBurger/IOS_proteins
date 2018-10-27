//
//  SceneViewController.swift
//  Swifty_Proteins
//
//  Created by Lance CHANT on 2018/10/25.
//  Copyright © 2018 Lance CHANT. All rights reserved.
//

import UIKit
import SceneKit
import Alamofire

struct Atom {
    var index:Int
    var x: Float
    var y: Float
    var z: Float
    var name: String
    var connection: [Int]
}

class SceneViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var SceneView: SCNView!
    //var SceneView:SCNView!
    var Scene:SCNScene!
    var SceneCamera:SCNNode!
    var CreationTime:TimeInterval = 0
    var atoms:[Atom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initScene()
        initCamera()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadData(Selected: selectedCell!)
    }
    
    func downloadData(Selected: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(Selected)_ideal.pdb")
            return (documentsURL, [.removePreviousFile])
        }
        Alamofire.download("https://files.rcsb.org/ligands/view/\(Selected)_ideal.pdb", to: destination).responseData {
            response in
            if response.result.isSuccess {
                if response.result.value == nil {
                    print("NIL download")
                    return
                }
                if let URL = response.destinationURL {
                    do {
                        let Ligand = try String(contentsOf: URL, encoding: .utf8)
                        if Ligand.isEmpty {
                            print("EMPTY")
                            return
                        }
                        self.SortData(Data: Ligand)
                    }
                    catch {
                        print("ERROR")
                    }
                }
            }
        }
    }
    
    func SortData(Data: String) {
        let lines = Data.components(separatedBy: .newlines)
        for words in lines {
            let word = words.split(separator: " ")
            if word[0] == "ATOM" {
                let index = Int(String(word[1]))
                let x = Float(String(word[6]))
                let y = Float(String(word[7]))
                let z = Float(String(word[8]))
                let name = String(word[11])
                let temp = Atom(index: index!, x: x!, y: y!, z: z!, name: name, connection:[])
                self.atoms.append(temp)
            }else if word[0] == "CONECT" {
                let index = Int(String(word[1]))
                var i = 0
                for connect in word {
                    print("for loop ", connect)
                    if i >= 2
                    {
                        let temp = Int(String(connect))
                        if index! < temp!
                        {
                            self.atoms[index! - 1].connection.append(temp!)
                        }
                    }
                    i += 1
                }
                
            }else if word[0] == "END" {
                break;
            }
        }
        createTarget()
        
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
        
        SceneCamera.position = SCNVector3(x: 0, y:0, z: 30)
        
        Scene.rootNode.addChildNode(SceneCamera)
    }
    
    func createTarget() {
        DispatchQueue.main.async {
        var rando:UIColor;
            
//            let v1 = SCNVector3(x: self.atoms[0].x, y: self.atoms[0].y, z: self.atoms[0].z)
//            let v2 = SCNVector3(x: self.atoms[5].x, y: self.atoms[5].y, z: self.atoms[5].z)
//            let connection:SCNNode = CylinderLine(parent: self.Scene.rootNode, v1: v1, v2: v2, radius: 0.1, radSegmentCount: 10, color: .gray)
//            self.Scene.rootNode.addChildNode(connection)
        
                for items in self.atoms {
                    let geometry:SCNGeometry = SCNSphere(radius: 0.5)
                    if items.name == "C" {
                        rando = UIColor.lightGray
                    }else {
                        rando = UIColor.green
                    }
                    geometry.materials.first?.diffuse.contents = rando
                    let geometryNode = SCNNode(geometry: geometry)
                    geometry.name = items.name
                    print(items.x, items.y, items.z)
                    geometryNode.position = SCNVector3(x: items.x, y: items.y, z: items.z)
                    self.Scene.rootNode.addChildNode(geometryNode)
                
                    if items.connection.count > 0 {
                        for connection1 in items.connection {
                            let v1 = SCNVector3(x: items.x, y: items.y, z: items.z)
                            let temp = self.atoms[connection1 - 1] as Atom
                            let v2 = SCNVector3(x: items.x, y: items.y, z: items.z)
                            let connection:SCNNode = CylinderLine(parent: self.Scene.rootNode, v1: v1, v2: v2, radius: 0.1, radSegmentCount: 10, color: .red)
                            self.Scene.rootNode.addChildNode(connection)
                        }
                    }
            }
        }
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        if time > CreationTime {
//            createTarget()
//            CreationTime = time + 0.6
//        }
//        cleanup()
//    }
    
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
