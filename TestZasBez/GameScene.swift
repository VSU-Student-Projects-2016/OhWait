////
//  GameScene.swift
//  TestZasBez
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let playButton = SKSpriteNode(imageNamed: "play")
    
    override func didMove(to view: SKView) {
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.playButton)
        self.backgroundColor = UIColor.blue
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("Touch began")
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.playButton {
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: "PlayScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        view.presentScene(scene)
                    }
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }

               // print("Touch began on PlayButton")
            }
        }
}
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
