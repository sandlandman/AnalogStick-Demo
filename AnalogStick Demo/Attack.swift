
//

import Foundation
import SpriteKit

@available(iOS 10.0, *)
class Attack{
    
    var spikeCategory = 2;

    
    var positionX: CGFloat
    var positionY: CGFloat
    var attack = SKSpriteNode()
    var dirRight = false
    
    var TextureAtlasScratch = SKTextureAtlas()
    var TextureArrayScratch = [SKTexture]()
    
    init(positionX: CGFloat, positionY: CGFloat) {
        self.positionX = positionX
        self.positionY = positionY
    }
    
    func setUp(){
        TextureAtlasScratch = SKTextureAtlas(named: "cut_c")
        for i in 1...TextureAtlasScratch.textureNames.count{
            let Name = "cut_c_000\(i).png"
            TextureArrayScratch.append(SKTexture (imageNamed: Name))
        }
        
        attack = SKSpriteNode(imageNamed: "cut_c_0001")
        attack.name = "slashAttack"
        attack.physicsBody = SKPhysicsBody(rectangleOf: attack.size)
        attack.physicsBody?.affectedByGravity = false
        attack.zPosition = 2
        attack.physicsBody?.restitution = 0.0
        attack.physicsBody?.friction = 0.0
        attack.physicsBody?.collisionBitMask = 0
        attack.physicsBody!.contactTestBitMask = attack.physicsBody!.collisionBitMask
        attack.position.x = positionX
        
     
    }
    
    func hit(){
        let scratchAttack = (SKAction.repeat(SKAction.animate(with: TextureArrayScratch, timePerFrame: 0.1), count: 1))
        let sequence = SKAction.sequence([scratchAttack])
        self.attack.run(sequence)
    }
  
}
