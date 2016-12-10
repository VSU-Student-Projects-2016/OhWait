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
    
    
    let playButton = SKSpriteNode(imageNamed: "btnPlay")
    var soundButton:SKSpriteNode?
    var defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.playButton)
        if (defaults.bool(forKey: "btnSound")){
            soundButton = SKSpriteNode(imageNamed: "sound_on")
        } else {soundButton = SKSpriteNode(imageNamed: "sound_off")}
        soundButton?.scale(to: CGSize.init(width: 30, height: 30))
        soundButton?.position = CGPoint.init(x: self.frame.midX - 260, y: self.frame.midY + 140)
        self.addChild(soundButton!)
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
            if self.atPoint(location) == self.soundButton {
                if let view = self.view {
                    let previousValue = defaults.bool(forKey: "btnSound")
                    defaults.set(!previousValue, forKey: "btnSound")
                    defaults.synchronize()
                    if (defaults.bool(forKey: "btnSound")){
                        
                        soundButton?.texture = SKTexture(imageNamed: "sound_on")
                    } else {soundButton?.texture = SKTexture(imageNamed: "sound_off")}
                }
                
                // print("Touch began on soundButton")
            }

        }
}
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
