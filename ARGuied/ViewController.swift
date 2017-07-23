//
//  ViewController.swift
//  ARGuied
//
//  Created by Sasha Prokhorenko on 7/16/17.
//  Copyright © 2017 YOOP. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var treeNode: SCNNode?
  
    override func viewDidLoad() {
      super.viewDidLoad()

      sceneView.delegate = self
      sceneView.showsStatistics = true
      let scene = SCNScene(named: "art.scnassets/Lowpoly_tree_sample.dae")!
      self.treeNode = scene.rootNode.childNode(withName: "Tree_lp_11", recursively: true)
      self.treeNode?.position = SCNVector3(0, 0, -1)
      sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingSessionConfiguration()
        sceneView.session.run(configuration)
    }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
    guard let hitFeature = results.last else { return }
    let hitTransform = SCNMatrix4(hitFeature.worldTransform)
    let hitPosition = SCNVector3Make(hitTransform.m41,
                                     hitTransform.m42,
                                     hitTransform.m43)
    let treeClone = treeNode!.clone()
    treeClone.position = hitPosition
    sceneView.scene.rootNode.addChildNode(treeClone)
  }
}
