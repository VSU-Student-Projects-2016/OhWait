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
    case coin
    case heart
    case bomb
    case clock
    
    var color: SKColor {
        switch self {
        case .coin:
            return SKColor.yellow
        case .heart:
            return SKColor.red
        case .bomb:
            return SKColor.black
        case .clock:
            return SKColor.green
        }
    }
    var mask: UInt32{
        switch self {
        case .coin:
            return ColliderType.Circle
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
        } else if arc4random() % 2 == 0 {//29
            type = .heart
        } else if arc4random() % 5 == 0 {//23
            type = .clock
        } else {
            type = .coin
        }
        
        var move:SKPhysicsBody
        var texture = SKTexture(imageNamed: "heart")
        if (type == .heart){
            let ball = SKSpriteNode.init(texture: texture, color: .clear, size: texture.size())
            move = SKPhysicsBody.init(circleOfRadius: texture.size().height/2)
            move.allowsRotation = true
            self.ball = ball
        }
        else{
        let w = 18.5
        let ball = SKShapeNode.init(circleOfRadius: CGFloat(w))
        ball.position = CGPoint.zero
        ball.fillColor = type.color
        ball.strokeColor = ball.fillColor
        self.ball = ball
        
        move=SKPhysicsBody.init(circleOfRadius: CGFloat(w))
        }
        self.ball.physicsBody=move
        self.addChild(self.ball)
        move.affectedByGravity=true
        move.isDynamic=true
        move.categoryBitMask = type.mask
        move.contactTestBitMask = ColliderType.Ground | ColliderType.Basket
        move.collisionBitMask = ColliderType.Shelf | ColliderType.Ground | ColliderType.Circle
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

