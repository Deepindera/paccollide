//
//  GameViewController.swift
//  paccollide
//
//  Created by Deepindera on 28/06/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData);
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene");
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene;
            archiver.finishDecoding();
            return scene;
        } else {
            return nil;
        }
    }
}

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        //skView.frameInterval = 1;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.showsPhysics = true;
        
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFit
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
