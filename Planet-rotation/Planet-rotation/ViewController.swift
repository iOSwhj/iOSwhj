//
//  ViewController.swift
//  Planet-rotation
//
//  Created by Mengduan on 2023/5/28.

import UIKit
import SceneKit

//mercury
//venus
//earth
//mars
//saturn

var index : Int = 1
var nowIndex : Int = 1
class ViewController: UIViewController {
    //行星表面纹理UIimage数组
    var plents = ["mercury","venus","earth","mars","saturn"]
    
    
    
    lazy var sceneView : SCNView = {
        let sceneView = SCNView(frame: self.view.frame)
        sceneView.allowsCameraControl = true
        //使用系统填充颜色（跟随系统明暗模式变换）
        sceneView.backgroundColor = .secondarySystemFill
        return sceneView
    }()
    
    lazy var scene : SCNScene = {
       let scene = SCNScene(named: "SceneKit Scene.scn")
        let sunNode = scene?.rootNode.childNode(withName: "sun", recursively: false)
        sunNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
        sunrotation(node: sunNode!)
        //光圈
        let sunHaloNode = SCNNode()
        sunHaloNode.geometry = SCNPlane(width: (sunNode?.frame.size.width)!, height: (sunNode?.frame.size.height)!)
        sunHaloNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sunhalo")
        sunHaloNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        sunHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false
        sunHaloNode.opacity = 5
        sunNode?.addChildNode(sunHaloNode)
        
        for plent in plents {
            //遍历各个行星，添加其纹理diffuse.content
            let id = plent
            //recursively为false时，是在当前scene中查找withname，为true时是在全局查找
            let node = scene?.rootNode.childNode(withName: id, recursively: true)
            let ui = UIImage(named: id)
            node?.geometry?.firstMaterial?.diffuse.contents = ui
        }
        
        //SceneKit 可以将这六个图像用于一种称为天空盒的常见 3D 编程技术。通过使用这些图像作为场景的背景，SceneKit 从六张图像中创建一个立方体，并将整个场景放入立方体中。
        //创建一个包含六个天空盒图像的数组
        let skyboxui = (1...6).map{UIImage(named: "skybox\($0)")}
        scene?.background.contents = skyboxui
        return scene!
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .cyan
        self.view.addSubview(sceneView)
        sceneView.scene = scene
        
        for plent in plents {
            let id = plent
            let node = scene.rootNode.childNode(withName: id, recursively: true)
            plentrotation(node: node!)
            createNode(plent: node!)
        }
        
        
    }

    
    func createNode(plent : SCNNode){
        let nnode = SCNNode(geometry: SCNSphere(radius: 1))
        nnode.position = .init(x: 0, y: 0, z: 1)
        scene.rootNode.addChildNode(nnode)
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = SCNVector4(0, 1, 0, Float(Double.pi) * 2)
        animation.duration = CFTimeInterval(nowIndex)
        animation.repeatCount = Float.greatestFiniteMagnitude
        nnode.addChildNode(plent)
        nnode.addAnimation(animation, forKey: "sun-texture")
        nowIndex += 5
    }
    

}




func sunrotation(node : SCNNode){
    let animation = CABasicAnimation(keyPath: "rotation")
    animation.toValue = SCNVector4Make(0, 1, 0, Float(Double.pi) * 2)
    animation.duration = 10.0
    animation.repeatCount = Float.greatestFiniteMagnitude
    node.addAnimation(animation, forKey: "sun-texture")
    
    
}

func plentrotation(node : SCNNode){
    let animation = CABasicAnimation(keyPath: "rotation")
    animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, Double.pi * 2))//围绕自己的y轴转动
    animation.duration = CFTimeInterval(2 * index)
    animation.repeatCount = Float.greatestFiniteMagnitude
    node.addAnimation(animation, forKey: "earth rotation around sun")
//    node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: Double.pi*2, duration: TimeInterval(index))), forKey: "texture")
    index = index + 5
}


