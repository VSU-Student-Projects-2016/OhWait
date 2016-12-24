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
    public static var Food: UInt32 = 0b1000
    public static var Heart: UInt32 = 0b10000
    public static var Bomb: UInt32 = 0b100000
    public static var Clock: UInt32 = 0b1000000
    public static var Hero: UInt32 = 0b10000000
    public static var Arms: UInt32 = 0b100000000
    public static var Catch: UInt32 = 0b1000000000
}

enum MoveSide {
    case moveLeft
    case moveRight
    case stop
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
    var moveSide: MoveSide = .stop
    var isGameOver = false
    var speedAmp: CGFloat = 0
    var defaults = UserDefaults.standard
    var heroSide:Side = .left
    var armSide:Side = .none
    
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
    
    
    func CreateBackgraund(){
        let bgImage = SKSpriteNode(imageNamed: "_background")
        bgImage.position = CGPoint.init(x: self.frame.midX + 10, y: self.frame.midY)
        bgImage.zPosition = -100
        let microwaveImg = SKSpriteNode(imageNamed: "_microwave")
        microwaveImg.position = CGPoint.init(x: self.frame.midX + microwaveImg.size.width*2.73, y: self.frame.midY + microwaveImg.size.height*1.2)
        microwaveImg.zPosition = bgImage.zPosition + 10
        let fridgeImg = SKSpriteNode(imageNamed: "_fridge")
        fridgeImg.zPosition = bgImage.zPosition + 10
        fridgeImg.position = CGPoint.init(x: self.frame.midX - fridgeImg.size.width*1.35, y: self.frame.midY - fridgeImg.frame.height * 0.075)
        let tableImg = SKSpriteNode(imageNamed: "_table")
        tableImg.zPosition = bgImage.zPosition + 10
        tableImg.position = CGPoint.init(x: self.frame.midX + tableImg.size.width*1.5, y: self.frame.midY - tableImg.size.height*1)
        
        self.addChild(bgImage)
        self.addChild(microwaveImg)
        self.addChild(fridgeImg)
        self.addChild(tableImg)
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
            
            let image = joystickStickImageEnabled ? UIImage(named: "stickFront") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
        }
    }
    
    var joystickSubstrateImageEnabled = true {
        
        didSet {
            
            let image = joystickSubstrateImageEnabled ? UIImage(named: "stickBack") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
        }
    }
    
    let moveAnalogStick =  🕹(diameter: 100)
    let rotateAnalogStick = AnalogJoystick(diameter: 100)
    
    func gameOver(){
        self.isPaused = !self.isPaused
        gameover = GameOverScene(frame: (view?.frame)!, score: Int32(self.score), highscore: Int32(defaults.integer(forKey: "highScore")))
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
            armSide = .none
            scorelabel?.removeFromSuperview()
            scene.scaleMode = .aspectFill
            touchCap?.removeFromSuperview()
            gameover?.removeFromSuperview()
            view?.presentScene(scene)
        }
    }
    
    func exitBtnPressed(_ sender: UIButton!) {
        if let scene = GameScene.unarchiveFromFile(file: "GameScene") as? GameScene {
            armSide = .none
            let skView = self.view as SKView!
            skView?.ignoresSiblingOrder = true
            scene.size = (skView?.bounds.size)!
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
            scorelabel?.removeFromSuperview()
            touchCap?.removeFromSuperview()
            gameover?.removeFromSuperview()
        }
    }
    
    override func didMove(to view: SKView) {
        CreateBackgraund()
        
        speedAmp = UIScreen.main.bounds.size.width / 568
        
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
        floor.fillColor = .clear
        floor.strokeColor = .clear
        self.addChild(floor)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
        }
        
        let movefloor = SKPhysicsBody(rectangleOf: .init(width: w, height: 32), center: CGPoint.init(x: w/2, y: 0))
        floor.physicsBody = movefloor
        movefloor.affectedByGravity = false
        movefloor.isDynamic = false
        movefloor.categoryBitMask = ColliderType.Ground
        movefloor.contactTestBitMask = ColliderType.Food
        movefloor.collisionBitMask =  ColliderType.Food | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart | ColliderType.Hero
        
        createAllShelfs()
        hero = Hero()
        hero.hero.position = .init(x: 0, y: -30)
        hero.add(to: self)
        hero.turn(to: .none)
        
        physicsWorld.contactDelegate = self
        view.showsPhysics = true

        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        moveAnalogStick.position = CGPoint(x: -self.size.width/2 + 2 * rotateAnalogStick.radius, y: -self.size.height/6 + 5/3 * rotateAnalogStick.radius)
        addChild(moveAnalogStick)
        
        rotateAnalogStick.position = CGPoint(x: self.size.width/2 - 2 * rotateAnalogStick.radius, y: -self.size.height/6 + 5/3 * rotateAnalogStick.radius)
        addChild(rotateAnalogStick)
        
        //запуск анимации
        moveAnalogStick.trackingHandler = { [unowned self] (data: AnalogJoystickData) in
            self.hero.hero.physicsBody?.velocity = CGVector(dx: 10 * data.velocity.x, dy: 0.0)
            if ((self.moveSide == .stop) || ((self.moveSide == .moveLeft) && (data.velocity.x > 0)) || ((self.moveSide == .moveRight) && (data.velocity.x < 0))){
                self.hero.run(to: self.heroSide)
                if (data.velocity.x > 0){
                    self.moveSide = .moveRight
                } else {self.moveSide = .moveLeft}
            }
        }
        //остановка анимации
        moveAnalogStick.stopHandler = {
            self.hero.hero.physicsBody?.velocity = CGVector.zero
            self.hero.stopRunning(to: self.heroSide, to: self.armSide)
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] data in
            guard abs(data.velocity.x) > 4.0 else {
                return
            }
            
            if data.velocity.x < 0 {
                if (self.heroSide != .left)
                {
                    self.heroSide = .left
                    self.hero.changeImage(to: .left)
                }
                self.hero.turn(to: .left)
                self.armSide = .left
                self.hero.arm.physicsBody?.angularVelocity = self.speedAmp * -data.velocity.y

            } else {
                if (self.heroSide != .right)
                {
                    self.heroSide = .right
                    self.hero.changeImage(to: .right)
                }
                self.hero.turn(to: .right)
                self.armSide = .right
                self.hero.arm.physicsBody?.angularVelocity = self.speedAmp * data.velocity.y
            }
        }
        
        rotateAnalogStick.stopHandler = {
            self.hero.turn(to: .none)
            self.armSide = .none
            self.hero.stopRunning(to: .none, to: self.armSide)
            self.hero.changeImage(to: .none)
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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        if isGameOver { return }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Catch | ColliderType.Food{
            let pos = contact.contactPoint
            if contact.bodyA.categoryBitMask == ColliderType.Food{
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
            if (defaults.bool(forKey: "btnSound")){
                coinSound.run(SKAction.sequence([playSound, remove]))
            }
            
            score += 1
            scorelabel?.text = String(score)
            print("Score: ", score)
            increaseDifficulty()
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Ground | ColliderType.Food{
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
                isGameOver = true
                print("Конец игры")
                if score > defaults.integer(forKey: "highScore") {
                    defaults.set(score, forKey: "highScore")
                    defaults.synchronize()
                }
                run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.run {
                    self.gameOver()}]))
            }else {
                lifesIndex[lifes].removeFromParent()
            }
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Catch | ColliderType.Bomb{
            if contact.bodyA.categoryBitMask == ColliderType.Bomb{
                contact.bodyA.node?.removeFromParent()
            } else{ contact.bodyB.node?.removeFromParent()}
            for _ in 0..<15{
                let particles = SKEmitterNode(fileNamed: "BombEffects")
                particles?.position = CGPoint(x: CGFloat.random(-self.size.width/2, self.size.width/2), y: CGFloat.random(-190.0, 190.0))
                self.addChild(particles!)
            }
            isGameOver = true
            print("Конец игры")
            
            let bombSound = SKAudioNode()
            bombSound.autoplayLooped = false
            self.addChild(bombSound)
            let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_BOMB, waitForCompletion: true)
            let remove = SKAction.removeFromParent()
            if (defaults.bool(forKey: "btnSound")){
                bombSound.run(SKAction.sequence([playSound, remove]))
            }
            if score > defaults.integer(forKey: "highScore") {
                defaults.set(score, forKey: "highScore")
                defaults.synchronize()
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.run {
                self.gameOver()}]))
        }
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == ColliderType.Catch | ColliderType.Heart{
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
                if (defaults.bool(forKey: "btnSound")){
                    heartSound.run(SKAction.sequence([playSound, remove]))
                }
                
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
            let clockEndSound = SKAudioNode()
            clockEndSound.autoplayLooped = false;
            self.addChild(clockSound)
            self.addChild(clockEndSound)
            let playSound = SKAction.playSoundFileNamed(SOUND_EFFECT_CLOCK, waitForCompletion: true)
            let remove = SKAction.removeFromParent()
            if (defaults.bool(forKey: "btnSound")){
                clockSound.run(SKAction.sequence([playSound, remove]))
            }
            let playEndSound = SKAction.playSoundFileNamed(SOUND_EFFECT_CLOCK_END, waitForCompletion: true)
            let endRemove = SKAction.removeFromParent()
            if (defaults.bool(forKey: "btnSound")){
                run(SKAction.sequence([SKAction.wait(forDuration: 8), SKAction.run {clockEndSound.run(SKAction.sequence([playEndSound, endRemove]))}]))
            }
            run(SKAction.sequence([SKAction.wait(forDuration: 10), SKAction.run {self.physicsWorld.speed = 1}]))
            print("Время")
        }
    }
}


