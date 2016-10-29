//
//  Shelf.swift
//  TestZasBez
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

class ShelfLeft:SKNode{
    var shelfLeft = SKShapeNode()
    
    func shapeShelfLeft() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: -50, y: 0))
        path.addLine(to: .init(x: 35, y: 0))
        path.addLine(to: .init(x: 165, y: -75))
        path.addLine(to: .init(x: 165, y: -91))
        path.addLine(to: .init(x: 35, y: -16))
        path.addLine(to: .init(x: -50, y: -16))
        path.addLine(to: .init(x: -50, y: 0))
        path.closeSubpath()
        return path
    }
    
    
    func physicsSelfLeft() -> SKPhysicsBody {
        let move = SKPhysicsBody(edgeChainFrom: shapeShelfLeft())
        move.affectedByGravity=false
        move.isDynamic=false
        move.categoryBitMask = ColliderType.Shelf
        move.collisionBitMask = ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart | ColliderType.Hero
        move.contactTestBitMask = ColliderType.None
        return move
    }
    
    
    func createShelf() {
        let pathLeft=shapeShelfLeft()
        shelfLeft = SKShapeNode(path: pathLeft)
        shelfLeft.position=CGPoint.zero
        shelfLeft.fillColor=SKColor.blue
        shelfLeft.strokeColor=shelfLeft.fillColor
        addChild(shelfLeft)
        shelfLeft.physicsBody=physicsSelfLeft()
    }
    
    override init(){
        //basket = SKSpriteNode(imageNamed: "basket.png")
        super.init()
        createShelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ShelfRight:SKNode{
    var shelfRight = SKShapeNode()


    func shapeShelfRight() -> CGPath {
        let path = CGMutablePath()
        path.move(to: .init(x: 50, y: 0))
        path.addLine(to: .init(x: -35, y: 0))
        path.addLine(to: .init(x: -165, y: -75))
        path.addLine(to: .init(x: -165, y: -91))
        path.addLine(to: .init(x: -35, y: -16))
        path.addLine(to: .init(x: 50, y: -16))
        path.addLine(to: .init(x: 50, y: 0))
        path.closeSubpath()
        return path
    }
    
    func physicsSelfRight() -> SKPhysicsBody {
        let move = SKPhysicsBody(edgeChainFrom: shapeShelfRight())
        move.affectedByGravity=false
        move.isDynamic=false
        move.categoryBitMask = ColliderType.Shelf
        move.collisionBitMask = ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart | ColliderType.Hero
        move.contactTestBitMask = ColliderType.None
        return move
    }
    
    func createShelf(){
        let pathRight=shapeShelfRight()
        shelfRight = SKShapeNode(path: pathRight)
        shelfRight.position=CGPoint.zero
        shelfRight.fillColor = SKColor.blue
        shelfRight.strokeColor = shelfRight.fillColor
        addChild(shelfRight)
        shelfRight.physicsBody = physicsSelfRight()
    }
    
    override init(){
        //basket = SKSpriteNode(imageNamed: "basket.png")
        super.init()
        createShelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
