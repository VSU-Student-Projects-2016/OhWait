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
        let width = self.size.width/568
        let height = self.size.height/320
        soundButton?.scale(to: CGSize.init(width: 30 * width, height: 30 * height))
        soundButton?.position = CGPoint.init(x: self.frame.midX - 260 * width, y: self.frame.midY + 140 * height)
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
                if self.view != nil {
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
