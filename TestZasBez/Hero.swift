//
//  Hero.swift
//  TestZasBez
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

class Hero:SKNode{
    var hero = SKShapeNode()
    var basket = SKShapeNode()
    var arm = SKShapeNode()
    
    var positionJoint: SKPhysicsJoint!
    var armJoin: SKPhysicsJointPin!
    var basketJoin: SKPhysicsJointFixed!
    
    func createBasket() {
        let w = 2048.00 * 0.05
        basket = SKShapeNode.init(rect: .init(x: -w/2, y: -w/10, width: w, height: w/5))
        basket.fillColor = SKColor.white
        basket.strokeColor = basket.fillColor
        //basket = SKSpriteNode(imageNamed: "basket.png")
        self.addChild(basket)
        
        let move = SKPhysicsBody.init(rectangleOf: .init(width: w, height: w/5))
        //let move = SKPhysicsBody.init(rectangleOf: .init(width: n.size.width, height: n.size.height))
        basket.physicsBody = move
        move.isDynamic=true
        move.categoryBitMask = ColliderType.Basket
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
        
        basket.position = .init(x: -130, y: 80)
    }
    
    func helpArmLeft() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: -50, y: 0))
        path.addLine(to: .init(x: -130, y: 50))
        path.addLine(to: .init(x: -130, y: 30))
        path.addLine(to: .init(x: -50, y: -30))
        //path.addLine(to: .init(x: -50, y: 0))
        path.closeSubpath()
        return path
    }
    func helpArmRight() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: -0, y: 0))
        path.addLine(to: .init(x: 130, y: 50))
        path.addLine(to: .init(x: 130, y: 30))
        path.addLine(to: .init(x: 50, y: -30))
        //path.addLine(to: .init(x: -50, y: 0))
        path.closeSubpath()
        return path
    }
    
    
    func createArm() {
        arm = SKShapeNode.init(path: helpArmLeft())
        //arm = SKShapeNode.init(rect: .init(x: -100, y: -12.5, width: 200, height: 25))
        arm.fillColor = SKColor.gray
        arm.strokeColor = arm.fillColor
        arm.position = CGPoint.init(x: -0, y: 30)
        
        
        let move = SKPhysicsBody.init(polygonFrom: helpArmRight())
        //let move = SKPhysicsBody.init(rectangleOf: .init(width: 200, height: 25))
        //move.affectedByGravity = false
        move.isDynamic = true
        arm.physicsBody = move
        self.addChild(arm)
        move.categoryBitMask = ColliderType.Arms
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.None
        
    }

    
    func createHero() {
        let size = CGSize(width: 150, height: 250)
        hero = SKShapeNode(rectOf: size)
        hero.fillColor = SKColor.gray
        hero.strokeColor = hero.fillColor
        self.addChild(hero)
        
        let move = SKPhysicsBody(rectangleOf: size)
        
        move.affectedByGravity=true
        move.allowsRotation = false
        move.isDynamic=true
        move.mass = 10
        hero.physicsBody = move
        move.categoryBitMask = ColliderType.Hero
        move.collisionBitMask = ColliderType.Ground | ColliderType.Shelf
        move.contactTestBitMask = ColliderType.None
        
        
        let body = SKPhysicsBody.init(circleOfRadius: 0.1)
        body.collisionBitMask = ColliderType.None
        body.contactTestBitMask = ColliderType.None
        
        createArm()
        createBasket()
        
        //positionJoint = SKPhysicsJointFixed.joint(withBodyA: hero.physicsBody!, bodyB: body, anchor: CGPoint(x:size.width / 2.0, y: 16.0))
        
        self.physicsBody = body
        
        armJoin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: .init(x: 0, y: 0))

        armJoin.frictionTorque = 10.0
        
        armJoin.shouldEnableLimits = true
        armJoin.upperAngleLimit = 0.1
        armJoin.lowerAngleLimit = -1
        
        basketJoin = SKPhysicsJointFixed.joint(withBodyA: arm.physicsBody!, bodyB: basket.physicsBody!, anchor: .init(x: -130, y:50))
    }
    
    public func add(to scene: SKScene) {
        scene.addChild(self)
        scene.physicsWorld.add(armJoin)
        scene.physicsWorld.add(basketJoin)
        //scene.physicsWorld.add(positionJoint)
    }
    
    override init(){
        super.init()
        createHero()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
