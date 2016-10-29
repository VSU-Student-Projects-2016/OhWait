//
//  Basket.swift
//  TestZasBez
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import SpriteKit

class Basket:SKNode{
    var basket = SKShapeNode()
    
    func createBasket() {
        let w = 2048.00 * 0.05
        basket = SKShapeNode.init(rect: .init(x: -w/2, y: -w/10, width: w, height: w/5))
        basket.fillColor = SKColor.white
        basket.strokeColor = basket.fillColor
        //basket = SKSpriteNode(imageNamed: "basket.png")
        self.addChild(basket)
        
        let move = SKPhysicsBody.init(rectangleOf: .init(width: w, height: w/5))
        //let move = SKPhysicsBody.init(rectangleOf: .init(width: basket.size.width, height: basket.size.height))
        basket.physicsBody = move
        move.affectedByGravity=false
        move.isDynamic=true
        move.categoryBitMask = ColliderType.Basket
        move.collisionBitMask = ColliderType.None
        move.contactTestBitMask = ColliderType.Circle | ColliderType.Bomb | ColliderType.Clock | ColliderType.Heart
    }
    
      override init(){
        //basket = SKSpriteNode(imageNamed: "basket.png")
        super.init()
        createBasket()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
