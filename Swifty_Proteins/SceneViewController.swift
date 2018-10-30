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
import Photos

struct Atom {
    var index:Int
    var x: Float
    var y: Float
    var z: Float
    var name: String
    var connection: [Int]
}

class SceneViewController: UIViewController, SCNSceneRendererDelegate {

    @IBOutlet weak var ProtienName: UILabel!
    @IBOutlet weak var SceneView: SCNView!
    //var SceneView:SCNView!
    var Scene:SCNScene!
    var SceneCamera:SCNNode!
    var CreationTime:TimeInterval = 0
    var atoms:[Atom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProtienName.text! = "Name: -"
        initView()
        initScene()
        initCamera()
        let button1 = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(tapbutton)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        // Do any additional setup after loading the view.
    }
//    let image = self.SceneView.snapshot()
    
    @objc func tapbutton() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    Alert.showBasicAlert(on: self, with: "Sharing Enabled", message: "You may now share")
                } else {
                    Alert.showBasicAlert(on: self, with: "Auth Error", message: "You may not share as you have not authorised")
                }
            })
        } else if photos == .authorized {
            let postText: String = "HELL YEAH LOOK at those proteins 😂😋"
            let image = self.SceneView.snapshot()
            let activityViewController = UIActivityViewController(activityItems: [postText, image], applicationActivities:nil)
            activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            activityViewController.popoverPresentationController?.sourceView = self.SceneView
            DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
            }
        }
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
                    Alert.showBasicAlert(on: self, with: "Error", message: "Nothing downloaded try again")
                    return
                }
                if let URL = response.destinationURL {
                    do {
                        let Ligand = try String(contentsOf: URL, encoding: .utf8)
                        if Ligand.isEmpty {
                            print("Ligand EMPTY")
                            return
                        }
                        self.SortData(Data: Ligand)
                    }
                    catch {
                        Alert.showBasicAlert(on: self, with: "Error", message: "Downloading Error")
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
        
                for items in self.atoms {
                    let geometry:SCNGeometry = SCNSphere(radius: 0.5)
                    rando = self.AtomColour(Name: items.name)
                    geometry.materials.first?.diffuse.contents = rando
                    let geometryNode = SCNNode(geometry: geometry)
                    geometryNode.position = SCNVector3(x: items.x, y: items.y, z: items.z)
                    geometryNode.name = items.name
                    self.Scene.rootNode.addChildNode(geometryNode)
                
                    if items.connection.count > 0 {
                        for connection1 in items.connection {
                            let v1 = SCNVector3(x: items.x, y: items.y, z: items.z)
                            let temp = self.atoms[connection1 - 1] as Atom
                            let v2 = SCNVector3(x: temp.x, y: temp.y, z: temp.z)
                            let connection:SCNNode = CylinderLine(parent: self.Scene.rootNode, v1: v1, v2: v2, radius: 0.1, radSegmentCount: 10, color: .red)
                            self.Scene.rootNode.addChildNode(connection)
                        }
                    }
            }
            CustomLoading.instance.HideGIf()        }
    }
    
    func AtomColour(Name: String) -> UIColor{
        if Name == "C" {
            return UIColor.lightGray
        } else if Name == "O" {
            return UIColor.red
        } else if Name == "H" {
            return UIColor.white
        } else if Name == "N" {
            return UIColor.init(red: (143 / 225), green: (143 / 255), blue: 1, alpha: 1)
        } else if Name == "S" {
            return UIColor.yellow
        } else if Name == "P" {
            return UIColor.orange
        } else if Name == "C" {
            return UIColor.green
        } else if Name == "Br" || Name == "Zn" {
            return UIColor.brown
        } else if Name == "Na" {
            return UIColor.blue
        } else if Name == "Fe" {
            return UIColor.orange
        } else if Name == "Mg" {
            return UIColor.init(red: (42 / 255), green: (128 / 255), blue: (42 / 255), alpha: 1)
        } else if Name == "Ca" {
            return UIColor.darkGray
        }
        return UIColor.init(red: 1, green: (20 / 255), blue: (147 / 255), alpha: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.location(in: SceneView)
        
        let hitTest = SceneView.hitTest(location, options: nil)
        
        if let hitObject = hitTest.first {
            let node = hitObject.node
            if node.name == nil {
                ProtienName.text! = "Name: -"
            } else {
                ProtienName.text! = "Name: " + node.name!
            }
            //add node name to label here
        }
    }
    
//    func cleanup() { //remove
//        for node in Scene.rootNode.childNodes {
//            if node.presentation.position.y < -2 {
//                node.removeFromParentNode()
//            }
//        }
//    }
    
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
