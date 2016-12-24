//
//  Ball.swift
//  TestZasBez
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import SpriteKit

enum Consumable {
    case food
    case heart
    case bomb
    case clock
    
    var texture: SKTexture {
        switch self {
        case .food:
            return getRandomFood()
        case .heart:
            return SKTexture(imageNamed: "_heart")
        case .bomb:
            return SKTexture(imageNamed: "_bomb")
        case .clock:
            return SKTexture(imageNamed: "_clock")
        }
    }
    
    func getRandomFood() -> SKTexture{
        let apple:SKTexture = SKTexture(imageNamed: "_apple")
        let cheese:SKTexture = SKTexture(imageNamed: "_cheese")
        let coco:SKTexture = SKTexture(imageNamed: "_coco")
        let egg:SKTexture = SKTexture(imageNamed: "_egg")
        let sausige:SKTexture = SKTexture(imageNamed: "_sausige")
        let tomato:SKTexture = SKTexture(imageNamed: "_tomato")
        let randomPoint = [apple,cheese,coco,egg,sausige,tomato]
        return randomPoint[Int(arc4random() % UInt32(randomPoint.count))]
    }
    
    var mask: UInt32{
        switch self {
        case .food:
            return ColliderType.Food
        case .heart:
            return ColliderType.Heart
        case .bomb:
            return ColliderType.Bomb
        case .clock:
            return ColliderType.Clock
        }
    }
}
class Ball:SKNode{
    var ball: SKNode!
    
    var didHitTheGround = false
    func createBall() {
        
        let type: Consumable
        if arc4random() % 100 > 95 {
            type = .bomb
        } else if arc4random() % 29 == 0 {//29
            type = .heart
        } else if arc4random() % 23 == 0 {//23
            type = .clock
        } else {
            type = .food
        }
        
        var move:SKPhysicsBody
        let texture:SKTexture = type.texture
        ball = SKSpriteNode.init(texture: texture, color: .clear, size: texture.size())
        move = SKPhysicsBody.init(circleOfRadius: texture.size().height/2)
        move.allowsRotation = true
        self.ball.physicsBody=move
        self.addChild(self.ball)
        move.affectedByGravity=true
        move.isDynamic=true
        move.categoryBitMask = type.mask
        move.contactTestBitMask = ColliderType.Ground | ColliderType.Catch
        move.collisionBitMask = ColliderType.Shelf | ColliderType.Ground | ColliderType.Food | ColliderType.Basket
    }
    
    override init(){
        //basket = SKSpriteNode(imageNamed: "basket.png")
        super.init()
        createBall()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

