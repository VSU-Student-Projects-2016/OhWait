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
    
    var texture: SKTexture {
        switch self {
        case .left:
            return SKTexture(imageNamed: "_arm_left")
        case .right:
            return SKTexture(imageNamed: "_arm_right")
        case .none:
            return SKTexture(imageNamed: "armStop")
        }
    }
}

class Hero {
    public var hero = SKSpriteNode()
    var basket = SKSpriteNode()
    var arm = SKSpriteNode()
    var catchBody = SKShapeNode()
    var positionJoint: SKPhysicsJoint!
    
    var armJoin: SKPhysicsJointPin!
    var basketJoin: SKPhysicsJointFixed!
    var catchJoin: SKPhysicsJointFixed!
    
    var orientation: Side = .left
    
    var texture: SKTexture!
    var walkFramesLeft = [SKTexture]()
    var walkFramesRight = [SKTexture]()
    
    func createBasket() -> SKSpriteNode {
        var basket = SKSpriteNode()
        var move = SKPhysicsBody()
        let texture:SKTexture = SKTexture.init(imageNamed: "_basket")
        basket = SKSpriteNode.init(texture: texture, color: .clear, size: texture.size())
        move = SKPhysicsBody.init(texture: texture, size: texture.size())
        
        basket.physicsBody = move
        move.isDynamic=true
        move.categoryBitMask = ColliderType.Basket
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.Food | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
        
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
    
    func createArm(to side: Side/*, heroframemidx: CGFloat*/) -> SKSpriteNode {
        var arm = SKSpriteNode()
        var move = SKPhysicsBody()
        let texture:SKTexture = side.texture
        arm = SKSpriteNode.init(texture: texture, color: .clear, size: texture.size())
        move = SKPhysicsBody.init(texture: texture, size: texture.size())
        
        move.mass = 0.7
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
                removeArm()
                self.orientation = Side.right
                
                let heroFrame = hero.frame
                
                arm = createArm(to: .right)
                arm.position = CGPoint(x: arm.frame.size.width, y: heroFrame.midY + heroFrame.size.height * 0.2)
                hero.addChild(arm)
                armJoin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: CGPoint.init(x: heroFrame.midX + heroFrame.size.width * 0.25, y: heroFrame.midY))
                
                
                armJoin.frictionTorque = 10.0
                
                armJoin.shouldEnableLimits = true
                armJoin.upperAngleLimit = 0.8
                armJoin.lowerAngleLimit = -1
                
                let armFrame = arm.frame
                basket = createBasket()
                arm.addChild(basket)
                basket.position = CGPoint(x: arm.frame.size.width/2, y:armFrame.size.height - basket.frame.size.height*0.75)
                print(armFrame)
                basketJoin = SKPhysicsJointFixed.joint(withBodyA: basket.physicsBody!, bodyB: arm.physicsBody!, anchor: CGPoint(x: arm.frame.maxX-10, y: armFrame.minY - 60))
                
                catchBody = SKShapeNode.init(rectOf: .init(width: basket.frame.size.width*0.6, height: 1))
                catchBody.fillColor = SKColor.green
                catchBody.position = CGPoint(x: basket.frame.midX - catchBody.frame.size.width, y: basket.frame.maxY - catchBody.frame.size.height);
                let catchB = SKPhysicsBody.init(rectangleOf: .init(width: basket.frame.size.width*0.8, height: 0.1))
                catchB.categoryBitMask = ColliderType.Catch
                catchB.collisionBitMask = ColliderType.None
                catchB.contactTestBitMask = ColliderType.Food | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
                catchBody.physicsBody = catchB;
                basket.addChild(catchBody)
                
                catchJoin = SKPhysicsJointFixed.joint(withBodyA: catchBody.physicsBody!, bodyB: basket.physicsBody!, anchor: CGPoint(x: basket.frame.midX - catchBody.frame.size.width, y: basket.frame.maxY))
                    
                hero.scene!.physicsWorld.add(armJoin)
                arm.scene!.physicsWorld.add(basketJoin)
                basket.scene?.physicsWorld.add(catchJoin)
                
            case .left:
                removeArm()
                self.orientation = Side.left
                
                let heroFrame = hero.frame
                
                arm = createArm(to: .left)
                arm.position = CGPoint(x: -arm.frame.size.width * 0.8, y: heroFrame.midY + heroFrame.size.height * 0.21)
                hero.addChild(arm)
                armJoin = SKPhysicsJointPin.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: CGPoint.init(x: heroFrame.midX - heroFrame.size.width * 0.16, y: heroFrame.midY))
                
                armJoin.frictionTorque = 10.0
                
                armJoin.shouldEnableLimits = true
                armJoin.upperAngleLimit = 0.85
                armJoin.lowerAngleLimit = -1
                
                let armFrame = arm.frame
                basket = createBasket()
                arm.addChild(basket)
                basket.position = CGPoint(x: -arm.frame.size.width/2, y: armFrame.minY + basket.frame.height * 2/3)
                basketJoin = SKPhysicsJointFixed.joint(withBodyA: basket.physicsBody!, bodyB: arm.physicsBody!, anchor: CGPoint(x: -arm.frame.size.width * 3/2, y: armFrame.minY))
                
                catchBody = SKShapeNode.init(rectOf: .init(width: basket.frame.size.width*0.6, height: 1))
                catchBody.fillColor = SKColor.clear
                catchBody.position = CGPoint(x: basket.frame.midX + catchBody.frame.size.width, y: basket.frame.maxY);
                let catchB = SKPhysicsBody.init(rectangleOf: .init(width: basket.frame.size.width*0.8, height: 0.1))
                catchB.categoryBitMask = ColliderType.Catch
                catchB.collisionBitMask = ColliderType.None
                catchB.contactTestBitMask = ColliderType.Food | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
                catchBody.physicsBody = catchB;
                basket.addChild(catchBody)
                
                catchJoin = SKPhysicsJointFixed.joint(withBodyA: catchBody.physicsBody!, bodyB: basket.physicsBody!, anchor: CGPoint(x: basket.frame.midX, y: basket.frame.maxY))
                    
                hero.scene!.physicsWorld.add(armJoin)
                arm.scene?.physicsWorld.add(basketJoin)
                basket.scene?.physicsWorld.add(catchJoin)
            case .none:
                removeArm()
                self.orientation = Side.none
                
                let heroFrame = hero.frame
                
                arm = createArm(to: .none)
                arm.position = CGPoint(x: arm.size.width*0.1, y: -arm.size.height*0.5)
                hero.addChild(arm)
                let armJoinNone = SKPhysicsJointFixed.joint(withBodyA: arm.physicsBody!, bodyB: hero.physicsBody!, anchor: CGPoint.init(x: heroFrame.midX - heroFrame.size.width * 0.16, y: heroFrame.midY))
                
                hero.scene!.physicsWorld.add(armJoinNone)
            }
        }
    }
    
    func createHero() {
        texture = SKTexture(imageNamed: "heroGoLeft1")
        let size = CGSize(width: 150, height: 250)
        hero = .init(texture: texture, color: .clear, size: size)
        let move = SKPhysicsBody(rectangleOf: size)
        
        walkFramesLeft.append(SKTexture(imageNamed: "heroGoLeft1"))
        walkFramesLeft.append(SKTexture(imageNamed: "heroGoLeft2"))
        walkFramesRight.append(SKTexture(imageNamed: "heroGoRight1"))
        walkFramesRight.append(SKTexture(imageNamed: "heroGoRight2"))
        
        move.affectedByGravity=true
        move.allowsRotation = false
        move.isDynamic=true
        move.mass = 30
        hero.physicsBody = move
        move.categoryBitMask = ColliderType.Hero
        move.collisionBitMask = ColliderType.Ground | ColliderType.Shelf
        move.contactTestBitMask = ColliderType.None
        
    }
    
    public func changeImage(to side: Side) {
        switch side {
        case .left:
            hero.texture = SKTexture(imageNamed: "heroGoLeft1")
        case .right:
            hero.texture = SKTexture(imageNamed: "heroGoRight1")
        case .none:
            hero.texture = SKTexture(imageNamed: "heroGoLeft1")
        }
    }
    
    public func run(to side: Side) {
        if (side == .left){
            hero.run(SKAction.repeatForever(SKAction.animate(with: walkFramesLeft,
                                                         timePerFrame: 0.2,
                                                         resize: false,
                                                         restore: true)), withKey: "run")
        }
        else {
            hero.run(SKAction.repeatForever(SKAction.animate(with: walkFramesRight,
                                                               timePerFrame: 0.2,
                                                               resize: false,
                                                               restore: true)), withKey: "run")
        }
    }
    
    public func stopRunning(to side: Side, to armside:Side) {
        hero.removeAction(forKey: "run")
        changeImage(to: side);
        hero.zPosition = 0
        if (armside != .none){
            arm.zPosition = hero.zPosition - 10
        }else { arm.zPosition = hero.zPosition + 10 }
        basket.zPosition = hero.zPosition + 10
    }
    
    public func add(to scene: SKScene) {
        scene.addChild(hero)
        turn(to: .none)
    }
    
    init(){
        createHero()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
