//
//  GameViewController.swift
//  TestZasBez
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        var sceneData = NSData()
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
            //var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            do {
                sceneData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
            } catch {
                print("Error in GameViewController unarchiveFromFile function")
            }
            
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            scene.size = skView.bounds.size
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
    @nonobjc
    func shouldAutorotate() -> Bool {
        return true
    }
    
    @nonobjc
    func supportedInterfaceOrientations() -> Int {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.all.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
