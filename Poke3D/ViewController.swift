//
//  ViewController.swift
//  Poke3D
//
//  Created by Alejandro Serna Rodriguez on 2/17/20.
//  Copyright © 2020 Alejandro Serna Rodriguez. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        sceneView.automaticallyUpdatesLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 5
            print("Images succesfully added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {

            var imageRoute = ""
            var imageName = ""

            switch imageAnchor.referenceImage.name {
            case "eevee-card":
                imageRoute = "Eevee/Eevee.DAE"
                imageName = "Eevee"
            case "oddish-card":
                imageRoute = "Oddish/Oddish.DAE"
                imageName = "Oddish"
            case "dragonite-card":
                imageRoute = "Dragonite/Dragonite.dae"
                imageName = "Dragonite"
            case "houndoom-card":
                imageRoute = "Houndoom/Houndoom.DAE"
                imageName = "Houndoom"
            default:
                imageRoute = "Blastoise/Blastoise.DAE"
                imageName = "Blastoise"
            }

            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "art.scnassets/\(imageRoute)") {
                if let pokeNode = pokeScene.rootNode.childNode(withName: imageName, recursively: true) {
                    pokeNode.eulerAngles.x = .pi / 2
                    planeNode.addChildNode(pokeNode)
                }
            }
        }

        return node
    }
}
