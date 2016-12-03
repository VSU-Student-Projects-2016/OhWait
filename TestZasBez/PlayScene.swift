//
//  GameScene.swift
//  TestZasBez
//
//  Created by xcode on 24.09.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
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



let GAME_LOOP_ACTION_TAG = "GAME_LOOP_ACTION_TAG"

class PlayScene: SKScene {
    
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
    private var touchCap: UIView?
    private var gameover: UIView?
    var isGameOver = false
    
    var count = 0
    var score = 0
    var scorelabel: UILabel?
    var lifes = 3
    var lifesIndex = [SKShapeNode]()
    
    var positionAdd:CGFloat = 20.0
    var difficulty: Int32 = 1
    var catchTime = false
    var countBalls: CGFloat = 0
    var spawnTimeInterval: TimeInterval = 3.0
    
    var pauseBigBtn: UIButton!
    var pauseBtn: UIButton!
    var restartBtn: UIButton!
    var exitBtn: UIButton!
    
    func increaseDifficulty() {
        if (score % 20 == 0){
            difficulty += 1
            
            removeAction(forKey: GAME_LOOP_ACTION_TAG)
            spawnTimeInterval -= 0.3
            
            if spawnTimeInterval < 0.6 {
                spawnTimeInterval += TimeInterval.random(1.0, 1.5)
            }
            
            beginGameLoop()
        }
    }
    
    func beginGameLoop() {
        let wait = SKAction.wait(forDuration: spawnTimeInterval)
        let spawn = SKAction.run {
            self.createBall()
        }
        let action = SKAction.repeatForever(SKAction.sequence([wait, spawn]))
        run(action, withKey: GAME_LOOP_ACTION_TAG)
    }
    
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
        if ball.position.x > 0 { ball.ball.physicsBody?.velocity=CGVector(dx:-50 + CGFloat(difficulty) * CGFloat.random(1, 1.5), dy:0) }
        else { ball.ball.physicsBody?.velocity=CGVector(dx:50 + CGFloat(difficulty) * CGFloat.random(1, 1.5),dy:0) }
        self.addChild(ball)
    }

    
    var joystickStickImageEnabled = true {
        
        didSet {
            
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
            //setJoystickStickImageBtn.text = joystickStickImageEnabled ? "Remove Stick Images" : "Set Stick Images"
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        
        didSet {
            
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
           //setJoystickSubstrateImageBtn.text = joystickSubstrateImageEnabled ? "Remove Substrate Images" : "Set Substrate Images"
            //rotateAnalogStick.
        }
    }
    
    let moveAnalogStick =  🕹(diameter: 100)
    let rotateAnalogStick = AnalogJoystick(diameter: 100)
    
    func gameOver(){
        self.isPaused = !self.isPaused
        gameover = GameOverScene(frame: (view?.frame)!, score: Int32(self.score))
        gameover?.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        gameover?.isUserInteractionEnabled = true
        pauseBtn.removeFromSuperview()
        restartBtn.backgroundColor = SKColor.yellow
        exitBtn.backgroundColor = SKColor.purple
        gameover?.addSubview(restartBtn)
        gameover?.addSubview(exitBtn)
        scorelabel?.removeFromSuperview()
        self.view?.addSubview(gameover!)
    }
    
    func pauseBtnPressed(_ sender: UIButton!){
        self.isPaused = !self.isPaused
        if self.isPaused{
            pauseBtn.removeFromSuperview()
            self.view?.addSubview(touchCap!)
        }
        else {
            touchCap?.removeFromSuperview()
            self.view?.addSubview(pauseBtn)
        }
    }
    
    func restartBtnPressed(_ sender: UIButton!) {
        if let scene = SKScene(fileNamed: "PlayScene") {
            scorelabel?.removeFromSuperview()
            scene.scaleMode = .aspectFill
            touchCap?.removeFromSuperview()
            gameover?.removeFromSuperview()
            view?.presentScene(scene)
        }
    }
    
    func exitBtnPressed(_ sender: UIButton!) {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
            touchCap?.removeFromSuperview()
            gameover?.removeFromSuperview()
        }
    }
    
    override func didMove(to view: SKView) {
        pauseBtn = UIButton(frame: CGRect(x: view.frame.maxX-80, y: view.frame.minY - 10, width: 100.0, height: 40.0))
        pauseBtn.setTitle("pause", for: .normal)
        pauseBtn.setTitleColor(.yellow ,for: .normal)
        pauseBtn.addTarget(self, action: #selector(self.pauseBtnPressed(_:)), for: .touchUpInside)
        self.view?.addSubview(pauseBtn)
        
        pauseBigBtn = UIButton(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY - 80, width: 100.0, height: 40.0))
        pauseBigBtn.setTitle("resume", for: .normal)
        pauseBigBtn.setTitleColor(.yellow ,for: .normal)
        pauseBigBtn.addTarget(self, action: #selector(self.pauseBtnPressed(_:)), for: .touchUpInside)
        
        restartBtn = UIButton(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY - 40, width: 100.0, height: 40.0))
        restartBtn.setTitle("restart", for: .normal)
        restartBtn.setTitleColor(.green ,for: .normal)
        restartBtn.addTarget(self, action: #selector(self.restartBtnPressed(_:)), for: .touchUpInside)
        
        exitBtn = UIButton(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY, width: 100.0, height: 40.0))
        exitBtn.setTitle("Exit", for: .normal)
        exitBtn.setTitleColor(.red, for: .normal)
        exitBtn.addTarget(self, action: #selector(self.exitBtnPressed(_:)), for: .touchUpInside)
        
        
        touchCap = TouchCap(frame: view.frame)
        guard let touchCap = self.touchCap else {
            fatalError("Touch cap must be allocated")
        }
        touchCap.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        touchCap.isUserInteractionEnabled = true
        touchCap.addSubview(exitBtn)
        touchCap.addSubview(restartBtn)
        touchCap.addSubview(pauseBigBtn)
        
        scorelabel = UILabel(frame: CGRect(x: view.frame.midX, y: view.frame.minY - 40, width: 100.0, height: 100.0))
        
        scorelabel?.textColor = SKColor.white
        scorelabel?.text = String(score)
        self.view?.addSubview(scorelabel!)
        
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
        movefloor.collisionBitMask =  ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart | ColliderType.Hero
        
        createAllShelfs()
        hero = Hero()
        hero.hero.position = .init(x: 0, y: -30)
        hero.add(to: self)
        physicsWorld.contactDelegate = self
        view.showsPhysics = true

        moveAnalogStick.position = CGPoint(x: -self.size.width/2 + 2 * rotateAnalogStick.radius, y: -self.size.height/6 + 5/3 * rotateAnalogStick.radius)
        addChild(moveAnalogStick)
        
        rotateAnalogStick.position = CGPoint(x: self.size.width/2 - 2 * rotateAnalogStick.radius, y: -self.size.height/6 + 5/3 * rotateAnalogStick.radius)
        addChild(rotateAnalogStick)
        
        moveAnalogStick.trackingHandler = { [unowned self] (data: AnalogJoystickData) in
            self.hero.hero.physicsBody?.velocity = CGVector(dx: 10 * data.velocity.x, dy: 0.0)
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] data in
            guard abs(data.velocity.x) > 4.0 else {
                return
            }
            
            if data.velocity.x < 0 {
                self.hero.turn(to: .left)
                self.hero.arm.physicsBody?.velocity = .init(dx: -100, dy: 15 * data.velocity.y)

            } else {
                self.hero.turn(to: .right)
                self.hero.arm.physicsBody?.velocity = .init(dx: 100, dy: 15 * data.velocity.y)
            }
        }
        
        view.isMultipleTouchEnabled = true
       
        for i in 0..<3 {
            
            lifesIndex.append(SKShapeNode.init(circleOfRadius: 10))
            lifesIndex[i].fillColor = SKColor.purple
            lifesIndex[i].strokeColor = lifesIndex[i].fillColor
            lifesIndex[i].position = CGPoint(x: -self.size.width/2 + positionAdd, y: 190)
            
            addChild(lifesIndex[i])
            
            positionAdd = positionAdd + 30.0
            
        }
        
        beginGameLoop()
        //run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 10.0), SKAction.run { self.difficulty+=1 }])))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* for t in touches {
            isCenter = (toPoint: t.location(in: self)).toPoint
            isTouch = true;
        }*/

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
}

extension PlayScene: SKPhysicsContactDelegate {
    func didBegin(_ contact:SKPhysicsContact) {
        
        if isGameOver{ return }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Circle{
            let pos = contact.contactPoint
            if contact.bodyA.categoryBitMask == ColliderType.Circle{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()}
            
            let particles = SKEmitterNode(fileNamed: "CoinEffects")
            particles?.position = pos
            self.addChild(particles!)
            
            let coinSound = SKAudioNode()
            coinSound.autoplayLooped = false
            self.addChild(coinSound)
            let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_EAT, waitForCompletion: true)
            let remove = SKAction.removeFromParent()
            coinSound.run(SKAction.sequence([playSound, remove]))
            
            score += 1
            scorelabel?.text = String(score)
            print("Score: ", score)
            increaseDifficulty()
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Ground | ColliderType.Circle{
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
                for _ in 0..<15{
                    let particles = SKEmitterNode(fileNamed: "BombEffects")
                    particles?.position = CGPoint(x: CGFloat.random(-self.size.width/2, self.size.width/2), y: CGFloat.random(-190.0, 190.0))
                    self.addChild(particles!)
                }
                print("Конец игры")
                run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.run {
                    self.gameOver()}]))
            }else {
                lifesIndex[lifes].removeFromParent()
            }
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Bomb{
            for _ in 0..<15{
                let particles = SKEmitterNode(fileNamed: "BombEffects")
                particles?.position = CGPoint(x: CGFloat.random(-self.size.width/2, self.size.width/2), y: CGFloat.random(-190.0, 190.0))
                self.addChild(particles!)
            }
            print("Конец игры")
            
            let bombSound = SKAudioNode()
            bombSound.autoplayLooped = false
            self.addChild(bombSound)
            let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_BOMB, waitForCompletion: true)
            let remove = SKAction.removeFromParent()
            bombSound.run(SKAction.sequence([playSound, remove]))
            
            run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.run {
                self.gameOver()}]))
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Heart{
            let pos = contact.contactPoint
            if contact.bodyA.categoryBitMask == ColliderType.Heart{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()}
            let particles = SKEmitterNode(fileNamed: "HeartEffects")
            particles?.position = pos
            self.addChild(particles!)
            if (lifes < 3) {
                addChild(lifesIndex[lifes])
                contact.bodyB.node?.removeFromParent()
                lifes += 1
                
                let heartSound = SKAudioNode()
                heartSound.autoplayLooped = false
                self.addChild(heartSound)
                let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_HEART, waitForCompletion: true)
                let remove = SKAction.removeFromParent()
                heartSound.run(SKAction.sequence([playSound, remove]))
                
            }
                print("lifes: ",lifes)
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Basket | ColliderType.Clock{
            if contact.bodyA.categoryBitMask == ColliderType.Clock{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()}
            self.physicsWorld.speed = 0.5
            
            let clockSound = SKAudioNode()
            clockSound.autoplayLooped = false
            self.addChild(clockSound)
            let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_CLOCK, waitForCompletion: true)
            let remove = SKAction.removeFromParent()
            clockSound.run(SKAction.sequence([playSound, remove]))
            
            run(SKAction.sequence([SKAction.wait(forDuration: 10), SKAction.run {self.physicsWorld.speed = 1}]))
            print("Время")
        }
    }
}


