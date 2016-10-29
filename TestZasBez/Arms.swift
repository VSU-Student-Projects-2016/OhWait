//
//  Arms.swift
//  TestZasBez
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

class ArmLeft:SKNode{
    var arm = SKShapeNode()
    
    func helpArm() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: -50, y: 0))
        path.addLine(to: .init(x: -170, y: 50))
        path.addLine(to: .init(x: -170, y: 30))
        path.addLine(to: .init(x: -50, y: -30))
        path.addLine(to: .init(x: -50, y: 0))
        path.closeSubpath()
        return path
    }
    
    func createArm() {
        let arm = SKShapeNode.init(path: helpArm())
        arm.fillColor = SKColor.gray
        arm.strokeColor = arm.fillColor
        self.addChild(arm)
        
        let move = SKPhysicsBody.init(edgeLoopFrom: helpArm())
        move.affectedByGravity = true
        //move.allowsRotation = false
        move.isDynamic = true
        arm.physicsBody = move
        move.categoryBitMask = ColliderType.Arms
        move.collisionBitMask = ColliderType.Shelf | ColliderType.Hero | ColliderType.Ground
        move.contactTestBitMask = ColliderType.None
        
    }
    
    override init(){
        //basket = SKSpriteNode(imageNamed: "basket.png")
        super.init()
        createArm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
