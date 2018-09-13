//
//  Enemy.swift
//  AnalogStick Demo
//
//  Created by Squidward on 8/19/18.
//  Copyright © 2018 xaxby. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    var hp: Int
    var sprite : String
    var enemy = SKSpriteNode()
    var push = false
    
    
    init(hp: Int, sprite: String) {
        self.hp = hp
        self.sprite =  sprite
    }
    
    func setUp(aN : SKSpriteNode){
        
        enemy = SKSpriteNode(imageNamed: "gray.png")
        enemy.position.x = aN.position.x + 20
        enemy.position.y = aN.position.y - 50
        enemy.zPosition = 2
        enemy.size = aN.size
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.restitution = 0.0
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.collisionBitMask = 0
    
    }
    
    func moveEnemy(aN : SKSpriteNode, facingRight : Bool){
        if(push == true){
            if(facingRight){
                enemy.position.x += 10
                push = false
            }
            else if(!facingRight){
                enemy.position.x -= 10
                push = false
            }
        }
        else{
            if(aN.position.x + 100 < enemy.position.x ){
                enemy.position.x -= 1
            }
            if (aN.position.x - 100 > enemy.position.x){
                enemy.position.x += 1
            }
        }
    }
}
