//
//  GameScene.swift
//  TestZasBez
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

public struct ColliderType {
    public static var None: UInt32 = 0b0
    public static var Basket: UInt32 = 0b1
    public static var Shelf: UInt32 = 0b10
    public static var Ground: UInt32 = 0b100
    public static var Circle: UInt32 = 0b1000
    public static var Heart: UInt32 = 0b10000
    public static var Bomb: UInt32 = 0b100000
    public static var Clock: UInt32 = 0b1000000
    public static var Hero: UInt32 = 0b10000000
    public static var Arms: UInt32 = 0b100000000
}

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    private var basket: Basket!
    private var hero: Hero!
    private var armLeft: ArmLeft!
    private var shelfLeftUp: ShelfLeft!
    private var shelfLeftDown: ShelfLeft!
    private var shelfRigthUp: ShelfRight!
    private var shelfRigthDown: ShelfRight!
    private var isCenter:CGPoint = CGPoint.zero
    private var isTouch:Bool = false
    
    var count = 0
    var score = 0
    var lifes = 3
    
    
    func createAllShelfs(){
        shelfLeftUp = ShelfLeft()
        shelfLeftDown = ShelfLeft()
        shelfLeftUp.position = CGPoint.init(x: -self.size.width/2, y: 120)
        shelfLeftDown.position = CGPoint.init(x: -self.size.width/2, y: 0)
        shelfRigthUp = ShelfRight()
        shelfRigthDown = ShelfRight()
        shelfRigthUp.position = CGPoint.init(x: self.size.width/2, y: 120)
        shelfRigthDown.position = CGPoint.init(x: self.size.width/2, y: 0)
        self.addChild(shelfLeftUp)
        self.addChild(shelfLeftDown)
        self.addChild(shelfRigthUp)
        self.addChild(shelfRigthDown)
    }
    
    func getRandomPos() -> CGPoint{
        let rLeftUp:CGPoint = CGPoint(x: -self.size.width/2-25, y: 145)
        let rLeftDown:CGPoint = CGPoint(x: -self.size.width/2-25, y: 25)
        let rRightUp:CGPoint = CGPoint(x: self.size.width/2+25, y: 145)
        let rRihgtDown:CGPoint = CGPoint(x: self.size.width/2+25, y: 25)
        let randomPoint = [rLeftUp,rLeftDown,rRightUp,rRihgtDown]
        return randomPoint[Int(arc4random() % UInt32(randomPoint.count))]
    }
    
    func createBall(){
        let ball = Ball()
        ball.position = getRandomPos()
        if ball.position.x > 0 { ball.ball.physicsBody?.velocity=CGVector(dx:-50,dy:0) }
          else { ball.ball.physicsBody?.velocity=CGVector(dx:50,dy:0) }
        self.addChild(ball)
    }

    
    override func didMove(to view: SKView) {
        let w = self.size.width
        let floor = SKShapeNode.init(rect: CGRect(origin: CGPoint.zero, size: CGSize.init(width: w, height: 32)))
        floor.position = CGPoint(x: -self.size.width/2, y: -214)
        floor.fillColor = SKColor.white
        self.addChild(floor)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
        }
        
        //let movefloor = SKPhysicsBody(edgeLoopFrom: CGRect(x: -50,y: 32,width: self.frame.size.width+100,height: self.frame.size.height-900))
        let movefloor = SKPhysicsBody(rectangleOf: .init(width: w, height: 32), center: CGPoint.init(x: w/2, y: 0))
        floor.physicsBody = movefloor
        movefloor.affectedByGravity = false
        movefloor.isDynamic = false
        movefloor.categoryBitMask = ColliderType.Ground
        movefloor.contactTestBitMask = ColliderType.Circle
        movefloor.collisionBitMask =  ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart | ColliderType.Hero //| ColliderType.Arms
        
        createAllShelfs()
        //basket = Basket()
        //self.addChild(basket)
        hero = Hero()
        hero.position = .init(x: 0, y: -30)
        hero.add(to: self)
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            isCenter = (toPoint: t.location(in: self)).toPoint
            isTouch = true;
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.basket?.position = (toPoint: t.location(in: self))}
        for t in touches {
            isCenter = (toPoint: t.location(in: self)).toPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouch = false
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        count+=1
        if (count%180==0){
            self.createBall()
        }
        if isTouch{
            //hero.arm.physicsBody?.velocity = .init(dx: 0, dy: -80)
            if isCenter.x > 0 {hero.hero.physicsBody?.velocity = CGVector(dx: 300.0, dy: 0.0)}
            else {if isCenter.x < 0 {hero.hero.physicsBody?.velocity = CGVector(dx: -300.0, dy: 0.0)}}
            if isCenter.y > 0 {hero.arm.physicsBody?.velocity = .init(dx: -10, dy: 300)}
            else {if isCenter.y < 0 {hero.arm.physicsBody?.velocity = .init(dx: -10, dy: -300)}}
        }else {hero.hero.physicsBody?.velocity = .init(dx: 0.0, dy: 0.0)}
        //print(hero.position)
        /*if isCenter.x > 0 {hero.position.x += 3}
        else {if isCenter.x < 0 {hero.position.x -= 3}}
        if isCenter.y > 0 {hero.basket.position.y += 3}
        else {if isCenter.y < 0 {hero.basket.position.y -= 3}}
        }*/
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Circle{
            if contact.bodyA.categoryBitMask == ColliderType.Circle{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()
                score += 1
                print("Score: ", score)
            }
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Ground | ColliderType.Circle{
            /*if contact.bodyA.categoryBitMask == ColliderType.Circle{
                contact.bodyA.contactTestBitMask = ColliderType.None
                contact.bodyA.node?.physicsBody = contact.bodyA
            }
            else{
                contact.bodyB.contactTestBitMask = ColliderType.None
                contact.bodyB.node?.physicsBody = contact.bodyB
            }*/
            
            let ball: Ball
            if let ba = contact.bodyA.node?.parent as? Ball {
                ball = ba
            } else {
                ball = contact.bodyB.node!.parent as! Ball
            }
            
            if !ball.didHitTheGround {
                lifes -= 1
                ball.didHitTheGround = true
            }
            print("lifes: ",lifes)
            if lifes < 0{
                print("Конец игры")
            }
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Bomb{
            print("Конец игры") }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Heart{
            if contact.bodyA.categoryBitMask == ColliderType.Heart{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()}
            if (lifes < 3) {lifes += 1}
                print("lifes: ",lifes) }
    }
}
