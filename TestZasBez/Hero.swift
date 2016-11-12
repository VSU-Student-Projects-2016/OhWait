//
//  Hero.swift
//  TestZasBez
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

enum Side {
    case left
    case right
    case none
}

class Hero {
    public var hero = SKShapeNode()
    var basket = SKShapeNode()
    var arm = SKShapeNode()
    
    var positionJoint: SKPhysicsJoint!
    
    var armJoin: SKPhysicsJointPin!
    var basketJoin: SKPhysicsJointFixed!
    //var armJoinRight: SKPhysicsJointPin!
    //var basketJoinRight: SKPhysicsJointFixed!
    
    var orientation: Side = .none
    
    func createBasket() -> SKShapeNode {
        let w = 2048.00 * 0.05
        let basket = SKShapeNode.init(rect: .init(x: -w/2, y: -w/10, width: w, height: w/5))
        basket.fillColor = SKColor.white
        basket.strokeColor = basket.fillColor
        //basket = SKSpriteNode(imageNamed: "basket.png")
        //self.addChild(basket)
        
        let move = SKPhysicsBody.init(rectangleOf: .init(width: w, height: w/5))
        basket.physicsBody = move
        move.isDynamic=true
        move.categoryBitMask = ColliderType.Basket
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
        
        return basket
    }
    
    func helpArmLeft() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: -50, y: 0))
        path.addLine(to: .init(x: -130, y: 50))
        path.addLine(to: .init(x: -130, y: 30))
        path.addLine(to: .init(x: -50, y: -30))
        path.closeSubpath()
        return path
    }
    func helpArmRight() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: 50, y: 0))
        path.addLine(to: .init(x: 130, y: 50))
        path.addLine(to: .init(x: 130, y: 30))
        path.addLine(to: .init(x: 50, y: -30))
        path.closeSubpath()
        return path
    }
    
    func removeArm() {
            arm.removeFromParent()
    }
    
    func createArm(to side: Side/*, heroframemidx: CGFloat*/) -> SKShapeNode {
        var arm = SKShapeNode()
        var move = SKPhysicsBody()
        if side == Side.left{
            arm = SKShapeNode.init(path: helpArmLeft())
            move = SKPhysicsBody.init(polygonFrom: helpArmLeft())
        } else {
            arm = SKShapeNode.init(path: helpArmRight())
            move = SKPhysicsBody.init(polygonFrom: helpArmRight())
        }
        arm.fillColor = SKColor.gray
        arm.strokeColor = arm.fillColor
        
       // arm.position = CGPoint(x: hero.frame.midX, y: hero.frame.midY + hero.frame.height * 0.25)
        
        move.isDynamic = true
        arm.physicsBody = move
        move.categoryBitMask = ColliderType.Arms
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.None
        
        return arm
    }

    func turn(to side: Side) {
        if side != self.orientation {
            switch side {
            case .right:
                if self.orientation != .none {
                    removeArm()
                }
                self.orientation = Side.right
                
                let heroFrame = hero.frame
                
                arm = createArm(to: .right)
                arm.position = CGPoint(x: 0, y: heroFrame.midY + heroFrame.height * 0.5)
                hero.addChild(arm)
                //hero.scene?.addChild(arm)
                armJoin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: CGPoint.init(x: heroFrame.midX, y: heroFrame.midY + heroFrame.height * 0.25))
                
                armJoin.frictionTorque = 10.0
                
                armJoin.shouldEnableLimits = true
                armJoin.upperAngleLimit = 0.8
                armJoin.lowerAngleLimit = -1
                
                let armFrame = arm.frame
                basket = createBasket()
                
                arm.addChild(basket)
                basket.position = CGPoint(x: armFrame.width*3/2, y: armFrame.minY + basket.frame.height)
                basketJoin = SKPhysicsJointFixed.joint(withBodyA: basket.physicsBody!, bodyB: arm.physicsBody!, anchor: CGPoint(x: armFrame.width*3/2, y: armFrame.minY + basket.frame.height/2))
                // basket.position = x: armFrame.maxX, armFrame.midY
                hero.scene!.physicsWorld.add(armJoin)
                arm.scene!.physicsWorld.add(basketJoin)
                
            case .left:
                if self.orientation != .none {
                    removeArm()
                }
                self.orientation = Side.left
                
                let heroFrame = hero.frame
                
                arm = createArm(to: .left)
                arm.position = CGPoint(x: 0, y: heroFrame.midY + heroFrame.height * 0.5)
                hero.addChild(arm)
                
                armJoin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: CGPoint.init(x: heroFrame.midX, y: heroFrame.midY + heroFrame.height * 0.25))
                
                armJoin.frictionTorque = 10.0
                
                armJoin.shouldEnableLimits = true
                armJoin.upperAngleLimit = 0.8
                armJoin.lowerAngleLimit = -1
                
                let armFrame = arm.frame
                basket = createBasket()
                arm.addChild(basket)
                basket.position = CGPoint(x: -armFrame.width*3/2, y: armFrame.minY + basket.frame.height)
                basketJoin = SKPhysicsJointFixed.joint(withBodyA: basket.physicsBody!, bodyB: arm.physicsBody!, anchor: CGPoint(x: -armFrame.width*3/2, y: armFrame.minY + basket.frame.height/2))
                //armJoinLeft = SKPhysicsJointPin.joint
                hero.scene!.physicsWorld.add(armJoin)
                arm.scene?.physicsWorld.add(basketJoin)
            case .none:
                removeArm()
            }
        }
    }
    
    func createHero() {
        let size = CGSize(width: 150, height: 250)
        hero = SKShapeNode(rectOf: size)
        hero.fillColor = SKColor.gray
        hero.strokeColor = hero.fillColor
        //self.addChild(hero)
        
        let move = SKPhysicsBody(rectangleOf: size)
        
        move.affectedByGravity=true
        move.allowsRotation = false
        move.isDynamic=true
        move.mass = 10
        hero.physicsBody = move
        move.categoryBitMask = ColliderType.Hero
        move.collisionBitMask = ColliderType.Ground | ColliderType.Shelf
        move.contactTestBitMask = ColliderType.None
        
    }
    
    public func add(to scene: SKScene) {
        scene.addChild(hero)
        turn(to: .none)
        /*armLeft.removeFromParent()
        basketLeft.removeFromParent()
        scene.physicsWorld.add(armJoinRight)
        scene.physicsWorld.add(basketJoinRight)
        scene.physicsWorld.add(positionJoint)*/
    }
    
    init(){
        createHero()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
