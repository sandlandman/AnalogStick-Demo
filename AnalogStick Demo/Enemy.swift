//
//  Enemy.swift
//  AnalogStick Demo
//
//  Created by Squidward on 8/19/18.
//  Copyright © 2018 xaxby. All rights reserved.
//

import Foundation
import SpriteKit

@available(iOS 10.0, *)
class Enemy {
    var hp: Int
    var sprite : String
    var enemy = SKSpriteNode()
    var push = false
    var dirRight = false
    
    var TextureAtlasEnemyCatIdle = SKTextureAtlas()
    var TextureArrayEnemyCatIdle = [SKTexture]()
    
    var TextureAtlasEnemyCatRun = SKTextureAtlas()
    var TextureArrayEnemyCatRun = [SKTexture]()
    
    var TextureAtlasScratch = SKTextureAtlas()
    var TextureArrayScratch = [SKTexture]()
    
    
    init(hp: Int, sprite: String) {
        self.hp = hp
        self.sprite =  sprite
    }
    
    func setUp(aN : SKSpriteNode){
        
        let roll = randomInt(min: -500, max: 500)
        
        enemy = SKSpriteNode(imageNamed: "catEnemy_1.png")
        enemy.position.x = aN.position.x + CGFloat (roll)
        enemy.position.y = aN.position.y - 20
        enemy.zPosition = 2
        enemy.size = aN.size
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.affectedByGravity = false;
        enemy.physicsBody?.restitution = 0.0
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.collisionBitMask = 0
    
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
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
            if(enemy.position.x >= aN.position.x + 10){
                enemy.position.x -= 1
                dirRight = false
                enemy.xScale = abs(enemy.xScale) * 1
            }
            else if (enemy.position.x < aN.position.x - 10){
                enemy.position.x += 1
                dirRight = true
                enemy.xScale = abs(enemy.xScale) * -1
            }
        }
        
        
        if(enemy.position.x < aN.position.x - 50){
            enemy.physicsBody?.velocity = CGVector(dx: 0, dy:  0)
        }
        if(enemy.position.x > aN.position.x + 50 ){
            enemy.physicsBody?.velocity = CGVector(dx: 0, dy:  0)
        }
        
    }
    
    func detectPlayer(){
        
    }
  
    
    func enemyIdle(){
        
        TextureAtlasEnemyCatIdle = SKTextureAtlas(named: "enemyCat_idle")
        for i in 1...TextureAtlasEnemyCatIdle.textureNames.count{
            let Name = "catEnemy_\(i).png"
            TextureArrayEnemyCatIdle.append(SKTexture (imageNamed: Name))
        }
        
        TextureAtlasEnemyCatRun = SKTextureAtlas(named: "enemyCatRun")
        for i in 1...TextureAtlasEnemyCatIdle.textureNames.count{
            let Name = "catRun_\(i).png"
            TextureArrayEnemyCatRun.append(SKTexture (imageNamed: Name))
        }
        
        TextureAtlasScratch = SKTextureAtlas(named: "cut_c")
        for i in 1...TextureAtlasScratch.textureNames.count{
            let Name = "cut_c_000\(i).png"
            TextureArrayScratch.append(SKTexture (imageNamed: Name))
        }
        
        let height =  (self.TextureArrayEnemyCatRun[1].size().height) / (self.TextureArrayEnemyCatIdle[0].size().height)
        let width = (self.TextureArrayEnemyCatRun[1].size().width) / (self.TextureArrayEnemyCatIdle[0].size().width)
        let h2 = (self.TextureArrayEnemyCatIdle[0].size().height) * height
        let w2 = (self.TextureArrayEnemyCatIdle[0].size().width) * width
        let size = CGSize(width: w2, height: h2)
        
        let randomFloat = CGFloat.random(in: 2.0...4.0)
        let scale = SKAction.scale(to: size, duration: 0)
        
        let idle = (SKAction.repeat(SKAction.animate(with: TextureArrayEnemyCatIdle, timePerFrame: 0.1), count: 1))
        let run = (SKAction.repeatForever(SKAction.animate(with: TextureArrayEnemyCatRun, timePerFrame: 0.1)))
        
        let sequence = SKAction.sequence([ scale,idle,run])
        self.enemy.run(sequence)
    }
}
