import SpriteKit
import AudioToolbox
import MediaPlayer

@available(iOS 10.0, *)
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var idle = true
    
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    var TextureAtlasShootWalk = SKTextureAtlas()
    var TextureAtlasWalk = SKTextureAtlas()
    var TextureAtlasIdle = SKTextureAtlas()
    var TextureAtlasBlast = SKTextureAtlas()
    var TextureAtlasBlastBall = SKTextureAtlas()
    var TextureAtlasBlastBallEnd = SKTextureAtlas()
    var TextureAtlasSuperCat = SKTextureAtlas()
    var TextureAtlasCatKick = SKTextureAtlas()
    var TextureAtlasCharge = SKTextureAtlas()
    var TextureAtlasEnemyCatIdle = SKTextureAtlas()

    var TextureArrayShootWalk = [SKTexture]()
    var TextureArrayWalk = [SKTexture]()
    var TextureArrayIdle = [SKTexture]()
    var TextureArrayBlast = [SKTexture]()
    var TextureArrayBlastHold = [SKTexture]()
    var TextureArrayBlastBall = [SKTexture]()
    var TextureArrayBlastBallEnd = [SKTexture]()
    var TextureArraySuperCat = [SKTexture]()
    var TextureArraySuperCatHold = [SKTexture]()
    var TextureArrayCatKick = [SKTexture]()
    var TextureArrayCharge = [SKTexture]()
    var TextureArrayChargeHold = [SKTexture]()
    var TextureArrayEnemyCatIdle = [SKTexture]()


    private var shootWalk: [SKTexture] = []
    
    var timer: Timer!
    var totalTime = 0.2


    var sky = SKSpriteNode( imageNamed : "sky.png")
    var ground = SKSpriteNode ( imageNamed: "black copy.png")
    
    var trees = SKSpriteNode (imageNamed: "backTree.png")
    var treeFront = SKSpriteNode (imageNamed: "backTree.png")
    var treeBack = SKSpriteNode (imageNamed: "backTree.png")
    
    var trees2 = SKSpriteNode (imageNamed: "frontTree.png")
    var treeFront2 = SKSpriteNode (imageNamed: "frontTree.png")
    var treeBack2 = SKSpriteNode (imageNamed: "frontTree.png")
    
    var m = SKSpriteNode (imageNamed: "backMountain.png")
    
    var enemy = SKSpriteNode(imageNamed: "gray.png")
    var enemyArray = [Enemy]()
    var enemyDictionary = [String : Enemy]()
    var enemyCount = 0

    
    
    var treeisFront = true
    var treeisBack = true
    var treeisFront2 = true
    var treeisBack2 = true
    
    
    var touching_wall = false
    var blasting = false
    var facingRight = true;
    var shootBullets = true
    
    var push = false
    var moveDown = true
    
    var shootNode: SKSpriteNode?
    var appleNode: SKSpriteNode?
    var blastNode : SKSpriteNode?
    
    
    let setJoystickStickImageBtn = SKLabelNode()
    let setJoystickSubstrateImageBtn = SKLabelNode()
    
    let moveAnalogStick = 🕹(diameter: 110) // from Emoji
    let rotateAnalogStick = AnalogJoystick(diameter: 100) // from Class
    let blastButton = 🕹(diameter: 50)
    let kickButton = 🕹(diameter: 50)
    let superKickButton = 🕹(diameter: 50)
    
    var scrollerBackTree : InfiniteScrollingBackground?
    var scrollerFrontTree : InfiniteScrollingBackground?
    var scrollerBackMountain : InfiniteScrollingBackground?
    var scrollerFrontMountain : InfiniteScrollingBackground?
    
    
    var masterSize = CGSize()
    

    var CameraNode: SKCameraNode?
    
    override func didMove(to view: SKView) {
       
        setUp()
        setUpBlastHandlers()
        if #available(iOS 10.0, *) {
            setUpCatHandlers()
        } else {
            // Fallback on earlier versions
        }
        setUpKickHandler()
        setSuperKickHandler()
        
        // Instantiate a new music player
        //let mp = MPMusicPlayerController.systemMusicPlayer
        //mp.play()
        
        sky.size.width = (scene?.frame.width)!
        sky.size.height = (scene?.frame.height)!
        sky.position = CGPoint(x : (scene?.frame.width)!/2 , y: (scene?.frame.height)!/2)
        sky.zPosition = -7
        addChild(sky)
        
        appleNode?.position.y = ground.position.y + ground.size.height/2
        appleNode?.position.x = ground.position.x + ground.size.width/2
        shootNode?.position.y = ground.position.y + ground.size.height/2
        shootNode?.position.x = ground.position.x + ground.size.width/2
        

        ground.size.width = (scene?.frame.width)!
        ground.position.x = (scene?.frame.maxX)!/2
        ground.position.y = (scene?.frame.minY)! + 20
        ground.zPosition = -5
        addChild(ground)
        
        m.size.width = UIScreen.main.bounds.size.width + 100
        m.size.height = UIScreen.main.bounds.size.height + 100
        m.position = CGPoint(x : (scene?.frame.width)!/2 , y: (scene?.frame.height)!/2 + 100)
        m.zPosition = -6
        addChild(m)
      
       
        createTree()

        //mp.nowPlayingItem?.title
        //let size2 = CGSize(width: 20, height: 30)
        //let scoreSprite = SKSpriteNode(color: SKColor.clear, size: size2)
        //addChild(scoreSprite)
        
        physicsWorld.contactDelegate = self

    }
    
    func createTree() {
        
        trees.size.width = (scene?.frame.width)!
        trees.size.height = (scene?.frame.height)!
        trees.position = CGPoint(x : (scene?.frame.width)!/2 , y: ground.position.y + ground.size.height + 100)
        trees.zPosition = -4
        addChild(trees)
        
        treeFront.size.width = (scene?.frame.width)!
        treeFront.size.height = (scene?.frame.height)!
        treeFront.position = CGPoint(x : (scene?.frame.width)!/2 + trees.size.width , y: ground.position.y + ground.size.height + 100)
        treeFront.zPosition = -4
        addChild(treeFront)
        
        treeBack.size.width = (scene?.frame.width)!
        treeBack.size.height = (scene?.frame.height)!
        treeBack.position = CGPoint(x : (scene?.frame.width)!/2 - trees.size.width , y: ground.position.y + ground.size.height + 100)
        treeBack.zPosition = -4
        addChild(treeBack)
        
        trees2.size.width = (scene?.frame.width)!
        trees2.size.height = (scene?.frame.height)!
        trees2.position = CGPoint(x : (scene?.frame.width)!/2 , y: ground.position.y + ground.size.height + 100)
        trees2.zPosition = -4
        addChild(trees2)
        
        treeFront2.size.width = (scene?.frame.width)!
        treeFront2.size.height = (scene?.frame.height)!
        treeFront2.position = CGPoint(x : (scene?.frame.width)!/2 + trees2.size.width , y: ground.position.y + ground.size.height + 100)
        treeFront2.zPosition = -4
        addChild(treeFront2)
        
        treeBack2.size.width = (scene?.frame.width)!
        treeBack2.size.height = (scene?.frame.height)!
        treeBack2.position = CGPoint(x : (scene?.frame.width)!/2 - trees2.size.width , y: ground.position.y + ground.size.height + 100)
        treeBack2.zPosition = -4
        addChild(treeBack2)
        
        
        
    }
    
    func moveTrees( _ first: SKSpriteNode, _ second: SKSpriteNode, _ third: SKSpriteNode, _ s: CGFloat){
    
        if (facingRight == true){
            first.position.x += s
            second.position.x += s
            third.position.x += s
        }
        else {
            first.position.x -= s
            second.position.x -= s
            third.position.x -= s
        }
    
    
    }

    
    func keepPlayerInBounds() {
        guard let aN = self.appleNode else {
            return
        }
        if aN.position.x < frame.minX + aN.size.width/2 {
            aN.position.x = frame.minX + aN.size.width/2
        }
        if aN.position.x > frame.maxX - aN.size.width/2 {
            aN.position.x = frame.maxX - aN.size.width/2
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //outOfBounds()
        //keepPlayerInBounds()
        if(facingRight == true){
            treeisFront = moveBackgroundFront(trees, treeFront, treeBack, treeisFront)
            treeisFront2 = moveBackgroundFront(trees2, treeFront2, treeBack2, treeisFront2)
            
        }
        else if (facingRight == false){
            treeisBack = moveBackgroundBack(trees, treeBack, treeFront, treeisBack)
            treeisBack2 = moveBackgroundBack(trees2, treeBack2, treeFront2, treeisBack2)
            
        }

        
        m.position.x = (appleNode?.position.x)!
        sky.position.x = (appleNode?.position.x)!
        ground.position.x = (appleNode?.position.x)!
        superKickButton.position.x = (appleNode?.position.x)! + 250
        kickButton.position.x = (appleNode?.position.x)! + 200
        blastButton.position.x = (appleNode?.position.x)! + 150
        moveAnalogStick.position.x = (appleNode?.position.x)! - 250
        rotateAnalogStick.position.x = (CameraNode?.position.x)! + 250
        CameraNode?.position.x = (appleNode?.position.x)!
        
        let keys = enemyDictionary.keys
        for key in keys {
            enemyDictionary[key]?.moveEnemy(aN: appleNode!, facingRight: facingRight)
        }
        if keys.count < 5 {
            createEnemy()
        }
        
    }
    
    
    
    func moveBackgroundFront(_ first: SKSpriteNode, _ second: SKSpriteNode, _ third: SKSpriteNode, _ loop: Bool) -> Bool{
        var loop2 = loop
        if((second.position.x  < (CameraNode?.position.x)! ) && loop == true) {
            
            first.position.x = (CameraNode?.position.x)! + first.size.width - 10
            third.position.x = second.position.x - first.size.width + 10
            loop2 = false
            
        }
        else if((first.position.x  < (CameraNode?.position.x)! ) && loop == false) {
            first.position.x = (CameraNode?.position.x)!
            second.position.x = (CameraNode?.position.x)! + first.size.width - 10
            third.position.x = first.position.x - first.size.width + 10
            loop2 = true
        }
        
       
        
        return loop2
        
    }
    
    func moveBackgroundBack(_ first: SKSpriteNode, _ second: SKSpriteNode, _ third: SKSpriteNode, _ loop: Bool) -> Bool{
        var loop2 = loop
        if((second.position.x > (CameraNode?.position.x)!) && loop == true) {
            
            first.position.x = (CameraNode?.position.x)! - first.size.width + 10
            third.position.x = second.position.x + first.size.width - 10
            loop2 = false
            
        }
        else if((first.position.x  > (CameraNode?.position.x)!) && loop == false) {
            first.position.x = (CameraNode?.position.x)!
            second.position.x = (CameraNode?.position.x)! - first.size.width + 10
            third.position.x = first.position.x + first.size.width - 10
            loop2 = true
        }
    
        return loop2

    }

    func catAnimation(_ animation: [SKTexture], _ action: String){
        
        var anim = [SKTexture]()
        anim = animation
        
        if action == "Cat"{
            guard let aN = self.appleNode else {
                return
            }
            let ani = (SKAction.repeatForever(SKAction.animate(with: anim, timePerFrame: 0.1)))
            let scale = SKAction.scale(to: 1, duration: 0)
            aN.run(SKAction.sequence([scale, ani]))
        }
        
        if action == "Blast"{
            guard let bN = self.blastNode else {
                return
            }
            bN.run(SKAction.repeatForever(SKAction.animate(with: anim, timePerFrame: 0.1)))
        }
        
        if action == "BlastEnd"{
            guard let bN = self.blastNode else {
                return
            }
            bN.run(SKAction.repeat(SKAction.animate(with: anim, timePerFrame: 0.1), count: 1))
        }
        
    }//End catAnimation
    func outOfBounds(){
        guard let bN = self.blastNode else {
            return
        }
        let screenSize = UIScreen.main.bounds
        //print(screenSize.minX,  bN.position.x )
        if  ((bN.position.x >= screenSize.maxX - 65) && touching_wall == false) || ((bN.position.x <= screenSize.minX + 65) && touching_wall == false)  {
            bN.removeAllActions()
            bN.physicsBody?.isDynamic = false
            bN.size = CGSize(width: 100, height: 100)
            catAnimation(TextureArrayBlastBallEnd, "BlastEnd")
            touching_wall = true
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.appleNode!.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayIdle, timePerFrame: 0.1)))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            let node = atPoint(touch.location(in: self))
            
            switch node {
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled
            default:
                break
                //print("Otherwise, do something else.")
                //addApple(touch.location(in: self))
            }
        }
    }
    func setRandomStickColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.stick.color = randomColor
        rotateAnalogStick.stick.color = randomColor
    }
    
    func setRandomSubstrateColor() {
        let randomColor = UIColor.random()
        moveAnalogStick.substrate.color = randomColor
        rotateAnalogStick.substrate.color = randomColor
    }
    var joystickStickImageEnabled = true {
        didSet {
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
            //setJoystickStickImageBtn.text = "\(joystickStickImageEnabled ? "Remove" : "Set") stick image"
            let image2 = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            blastButton.stick.image = image2
            kickButton.stick.image = image2
            superKickButton.stick.image = image2
        }
    }
    var joystickSubstrateImageEnabled = true {
        didSet {
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
            //setJoystickSubstrateImageBtn.text = "\(joystickSubstrateImageEnabled ? "Remove" : "Set") substrate image"
        }
    }
    
    

    //Setup
    func setUp(){
        
        //Declaration of background
        backgroundColor = UIColor.black
        
        screenWidth = self.view!.bounds.width
        screenHeight = self.view!.bounds.height
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        rotateAnalogStick.position = CGPoint(x: self.frame.maxX - rotateAnalogStick.radius - 15, y:rotateAnalogStick.radius + 15)
        blastButton.position = CGPoint(x: moveAnalogStick.radius , y: moveAnalogStick.radius + 100)
        kickButton.position = CGPoint(x: moveAnalogStick.radius + 50, y: moveAnalogStick.radius + 100)
        superKickButton.position = CGPoint(x: moveAnalogStick.radius + 100, y: moveAnalogStick.radius + 100)
        
        moveAnalogStick.zPosition = 4

        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
        
        setJoystickStickImageBtn.fontColor = UIColor.black
        setJoystickStickImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .bottom
        setJoystickStickImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y - btnsOffsetHalf)
        setJoystickSubstrateImageBtn.fontColor  = UIColor.black
        setJoystickSubstrateImageBtn.fontSize = 20
        setJoystickStickImageBtn.verticalAlignmentMode = .top
        setJoystickSubstrateImageBtn.position = CGPoint(x: frame.midX, y: moveAnalogStick.position.y + btnsOffsetHalf)
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
        setRandomStickColor()
        
        addApple(CGPoint(x: frame.midX, y: frame.midY))
        addChild(moveAnalogStick)
        addChild(rotateAnalogStick)
        addChild(blastButton)
        addChild(kickButton)
        addChild(superKickButton)
        addChild(setJoystickSubstrateImageBtn)
        addChild(setJoystickStickImageBtn)
        
        view?.isMultipleTouchEnabled = true
        
        blastNode?.physicsBody = SKPhysicsBody(circleOfRadius: max(blastNode!.size.width / 2, blastNode!.size.height / 2))
        blastNode?.physicsBody?.affectedByGravity = false
        blastNode?.physicsBody?.restitution = 0.0
        
    }
    @available(iOS 10.0, *)
    func setUpCatHandlers(){
        //Movement Controls
        moveAnalogStick.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            
            let height =  (self.TextureArrayShootWalk[0].size().height) / (self.TextureArrayIdle[0].size().height)
            let width = (self.TextureArrayShootWalk[0].size().width) / (self.TextureArrayIdle[0].size().width)
            let h2 = (self.TextureArrayIdle[0].size().height) * height
            let w2 = (self.TextureArrayIdle[0].size().width) * width
            let size = CGSize(width: w2, height: h2)
            self.masterSize = size
            
            
          let ani = (SKAction.repeatForever(SKAction.animate(with: self.TextureArrayShootWalk, timePerFrame: 0.05)))
            
          //let scale = SKAction.scale(to: size, duration: 0)
          aN.run(SKAction.sequence([ani]))
            //print(aN.position.y)
            
            AudioServicesPlaySystemSound(1519)
            self.pauseScroller(pause : false)
            
            if(self.moveDown == false){
                aN.position.y += 11
                self.moveDown = true
            }
            
        }
        moveAnalogStick.trackingHandler = { [unowned self] data in
            guard let aN = self.appleNode else {
                return
            }
            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.12), y: aN.position.y )
            if(data.velocity.x < 0 && self.facingRight != false){
                aN.xScale = -1
                self.facingRight = false
                //self.setMovementDirection()

            }
            else if(data.velocity.x >= 0 && self.facingRight != true){
                aN.xScale = 1
                self.facingRight = true
                //self.setMovementDirection()
                
            }
            self.moveTrees(self.trees2, self.treeBack2, self.treeFront2, 1.0)
            self.moveTrees(self.trees, self.treeBack, self.treeFront, 0.5)

            if(self.shootBullets == true){
                self.shoot()
                self.shootBullets = false
                self.startTimer()
             }
        }
        moveAnalogStick.stopHandler = { [unowned self] in
            //self.appleNode!.removeAllActions()
            guard let aN = self.appleNode else {
                return
            }
            let ani = (SKAction.repeatForever(SKAction.animate(with: self.TextureArrayIdle, timePerFrame: 0.07)))
            
            aN.run(SKAction.sequence([ani]))
            self.pauseScroller(pause : true)
            
            if(self.moveDown == true){
                aN.position.y += -11
                self.moveDown = false
            }
            //print(aN.position.y)
            
        }
        
        //Rotation Controls
        rotateAnalogStick.trackingHandler = { [unowned self] jData in
            //self.appleNode?.zRotation = jData.angular
        }
        rotateAnalogStick.stopHandler =  { [unowned self] in
        }
    }
    func setSuperKickHandler(){
        
        //Blast Controls
        superKickButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            self.blasting = false;
        
            aN.run(SKAction.repeat(SKAction.animate(with: self.TextureArrayCharge, timePerFrame: 0.1), count: 1))
            {
                aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayChargeHold, timePerFrame: 0.05)))
                bN.texture = SKTexture(imageNamed: "cat_launch")
                bN.size = CGSize(width: 50, height: 50)
                self.touching_wall = false
                bN.position = CGPoint(x:aN.position.x + 20, y: aN.position.y)
                bN.isHidden = false
                bN.physicsBody?.isDynamic = true
                if(self.facingRight){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: 180, dy: 0 )))
                }
                if(self.facingRight == false){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: -180, dy: 0 )))
                }
            }
        }
        superKickButton.trackingHandler = { [unowned self] jData in
            if(self.blasting == false){
                //self.catAnimation(self.TextureArraySuperCatHold, "Cat")
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        superKickButton.stopHandler = { [unowned self] in
            self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    func setUpKickHandler(){
        
        //Blast Controls
        kickButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            self.blasting = false;
            aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayCatKick, timePerFrame: 0.05)))
        }
        kickButton.trackingHandler = { [unowned self] jData in
            
            if(self.blasting == false){
                //self.catAnimation(self.TextureArrayBlastHold, "Cat")
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        kickButton.stopHandler = { [unowned self] in

            self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    func setUpBlastHandlers(){
        
        //Blast Controls
        blastButton.beginHandler = { [unowned self] in
            guard let aN = self.appleNode else {
                return
            }
            guard let bN = self.blastNode else {
                return
            }
            self.blasting = false;
            
            aN.run(SKAction.repeat(SKAction.animate(with: self.TextureArrayBlast, timePerFrame: 0.1), count: 1))
            {
                aN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayBlastHold, timePerFrame: 0.05)))
                bN.run(SKAction.repeatForever(SKAction.animate(with: self.TextureArrayBlastBall, timePerFrame: 0.05)))
                bN.size = CGSize(width: 100, height: 100  )
                self.touching_wall = false
                bN.position = CGPoint(x:aN.position.x + 20, y: aN.position.y)
                bN.isHidden = false
                bN.physicsBody?.isDynamic = true
                if(self.facingRight){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: 180, dy: 0 )))
                }
                if(self.facingRight == false){
                    bN.run(SKAction.sequence([SKAction.scaleX(to: -1, duration: 0.4)] ))
                    bN.physicsBody?.applyImpulse((CGVector(dx: -180, dy: 0 )))
                }
            }
        }
        blastButton.trackingHandler = { [unowned self] jData in
            if(self.blasting == false){
                //self.catAnimation(self.TextureArraySuperCatHold, "Cat")
                self.blasting = true
            }
            //bN.zRotation = jData.angular
            //bN.physicsBody?.applyImpulse(CGVector (dx: sin(aN.position.x) * 100, dy: cos(aN.position.y) * 100 ))
        }
        blastButton.stopHandler = { [unowned self] in
            self.catAnimation(self.TextureArrayIdle, "Cat")
            AudioServicesPlaySystemSound(1521)
        }
    }
    
    func setUpBackground(imageName: String, layer: CGFloat, y: Float, speed: Double, direction: String) -> InfiniteScrollingBackground{
        // Getting the images:
        let image = UIImage(named: imageName)
        let image2 = UIImage(named: imageName)
        let images = [ image!, image2! ]
        
        
        if direction == "right"{
            let scrollerTemp = InfiniteScrollingBackground(images: images, scene: self, scrollDirection: .right , speed: speed, y: y)
            scrollerTemp?.scroll()
            scrollerTemp?.zPosition = layer
                 return scrollerTemp!
        }
        if direction == "left"{
            let scrollerTemp = InfiniteScrollingBackground(images: images, scene: self, scrollDirection: .left , speed: speed, y: y)
            scrollerTemp?.scroll()
            scrollerTemp?.zPosition = layer
                 return scrollerTemp!
        }
        return InfiniteScrollingBackground(images: images, scene: self, scrollDirection: .left , speed: speed, y: y)!
    }
    
    func pauseScroller(pause : Bool){
        
        if(pause == true){
            scrollerBackMountain?.isPaused = true
            scrollerFrontMountain?.isPaused = true
            scrollerBackTree?.isPaused = true
            scrollerFrontTree?.isPaused = true
        }
        if(pause == false){
            scrollerBackMountain?.isPaused = false
            scrollerFrontMountain?.isPaused = false
            scrollerBackTree?.isPaused = false
            scrollerFrontTree?.isPaused = false
        }
       
        
    }
    
    func addApple(_ position: CGPoint) {
        
        TextureAtlasIdle = SKTextureAtlas(named: "idle")
        
        for i in 1...TextureAtlasIdle.textureNames.count{
            
            let Name = "idle_\(i).png"
            TextureArrayIdle.append(SKTexture (imageNamed: Name))
        }
        
        TextureAtlasShootWalk = SKTextureAtlas(named: "cat_walk_gun")
        
        for i in 1...TextureAtlasShootWalk.textureNames.count{
            
            let Name = "cat_walk_shot_\(i).png"
            TextureArrayShootWalk.append(SKTexture (imageNamed: Name))
        }
        
        TextureAtlasBlast = SKTextureAtlas(named: "cat_blast")
        
        for j in 1...4{
            
            let Name2 = "cat_blast_\(j).png"
            TextureArrayBlast.append(SKTexture (imageNamed: Name2))
        }
        
        for j in 1...8{
            
            let Name2 = "cat_blast_\(j+4).png"
            TextureArrayBlastHold.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasWalk = SKTextureAtlas(named: "cat_walk")
        
        for j in 1...TextureAtlasWalk.textureNames.count{
            
            let Name2 = "cat_walk_\(j).png"
            TextureArrayWalk.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasBlastBall = SKTextureAtlas(named: "cat_blast_ball")
        
        for j in 1...TextureAtlasBlastBall.textureNames.count{
            
            let Name2 = "cat_blast_ball_\(j).png"
            TextureArrayBlastBall.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasBlastBallEnd = SKTextureAtlas(named: "cat_blast_end")
        
        for j in 1...TextureAtlasBlastBallEnd.textureNames.count{
            
            let Name2 = "cat_blast_end_\(j).png"
            TextureArrayBlastBallEnd.append(SKTexture (imageNamed: Name2))
        }
        
        TextureAtlasSuperCat = SKTextureAtlas(named: "super_kick")
        
       for j in 1...10{
            
            let Name2 = "high_kick_\(j).png"
            TextureArraySuperCat.append(SKTexture (imageNamed: Name2))
        
        }
        for j in 1...2{
            
            let Name2 = "high_kick_\(j+8).png"
            TextureArraySuperCatHold.append(SKTexture (imageNamed: Name2))
        }
        TextureAtlasCatKick = SKTextureAtlas(named: "cat_kick")
        
        for j in 1...TextureAtlasCatKick.textureNames.count{
            
            let Name2 = "kick_\(j).png"
            TextureArrayCatKick.append(SKTexture (imageNamed: Name2))
        }
    
        TextureAtlasCharge = SKTextureAtlas(named: "cat_charge")
        for j in 1...TextureAtlasCharge.textureNames.count{
            
            let Name2 = "charge_\(j).png"
            TextureArrayCharge.append(SKTexture (imageNamed: Name2))
        }
        for j in 1...2{
            
            let Name2 = "charge_\(j+4).png"
            TextureArrayChargeHold.append(SKTexture (imageNamed: Name2))
        }
      
        let apple = SKSpriteNode(imageNamed: TextureAtlasWalk.textureNames[0] as String)
        let blast = SKSpriteNode(imageNamed: TextureAtlasBlastBall.textureNames[0] as String)
        let shootNode = SKSpriteNode(imageNamed: TextureAtlasShootWalk.textureNames[0] as String)
     
        
        
        apple.position.y = position.y - 50
        shootNode.position.y = position.y - 50
        blast.position = position
        
        appleNode = apple
        appleNode?.size = CGSize(width: 100, height: 100)
        blastNode = blast
        blastNode?.size = CGSize(width: 100, height: 100)
        blastNode?.isHidden = true
        shootNode.size.width = (appleNode?.size.width)!
        shootNode.size.height = (appleNode?.size.height)!
        
        CameraNode = SKCameraNode()
        
        addChild(CameraNode!)
        addChild(appleNode!)
        addChild(blast)
        //addChild(shootNode)
        
        camera = CameraNode
        CameraNode?.position.x = size.width/2
        CameraNode?.position.y = size.height/2
    }
    
    func createEnemy(){
        guard let aN = self.appleNode else {
            return
        }
        let name = "enemy\(enemyCount)"
        let enemyClone:Enemy = Enemy(hp: 100, sprite: "gray.png")

        //Hashmap = Dictionary
        enemyDictionary[name] = enemyClone
        enemyDictionary[name]?.setUp(aN: aN)
        enemyDictionary[name]?.enemy.name = name
        addChild((enemyDictionary[name]?.enemy)!)
        enemyDictionary[name]?.enemyIdle()
        enemyCount += 1
    }
    
    func moveEnemy(){
        guard let aN = self.appleNode else {
            return
        }
       
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
    
    func calcDistance(p1 : CGPoint, p2 : CGPoint) -> Double{
        let x = p1.x
        let y = p1.y
        let x2 = p2.x
        let y2 = p2.y
        let pos = (Int(x2 - x)^2) + (Int(y2 - y)^2)
        
        return sqrt(Double(pos))
        
    }
    
    func shoot(){
        
        guard let aN = self.appleNode else {
            return
        }
        
      //Physics Setup of Bullet
      let bullet = SKSpriteNode(imageNamed: "bullet.png")
      bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
      //bullet.physicsBody?.isDynamic = false
      bullet.physicsBody?.affectedByGravity = false
      bullet.name = "bullet"
      bullet.zPosition = 2
      bullet.physicsBody?.restitution = 0.0
      bullet.physicsBody?.friction = 0.0
      bullet.physicsBody!.contactTestBitMask = bullet.physicsBody!.collisionBitMask
      bullet.physicsBody?.collisionBitMask = 0
        
      bullet.position = aN.position
    
      var distance: CGFloat
    

        if(self.facingRight == true){
            bullet.xScale = 0.05
            bullet.yScale = 0.05
            bullet.position.x = aN.position.x + 50
            bullet.position.y = aN.position.y - 11
            distance = aN.position.x + 1000
        }
        else{
            bullet.xScale = -0.05
            bullet.yScale = 0.05
            bullet.position.x = aN.position.x - 50
            bullet.position.y = aN.position.y - 11
            distance = aN.position.x + -1000
        }
        
      let time: Double = 1
      let move = SKAction.moveTo(x: distance, duration: time)
      
     let sequence = SKAction.sequence([move, buildAction(bullet, _facingRight: self.facingRight, _distance: distance)])
        
     bullet.run(sequence)
      
     addChild(bullet)
     
    }
    
    func buildAction(_ bullet: SKSpriteNode, _facingRight: Bool, _distance: CGFloat) -> SKAction {
        return SKAction.run {
            if(bullet.position.x >= _distance || bullet.position.x <= _distance){
                bullet.removeFromParent()
            }
        
        }
    }
    
    //Delete explosion
    func buildActionBullet(_ object: SKSpriteNode) -> SKAction {
        return SKAction.run {
                object.removeFromParent()
        }
    }
    
    
    //Physics Collision Functions
    func collisionBetween(bullet: SKNode, object: SKNode) {
        
        let anim = (SKAction.repeat(SKAction.animate(with: self.TextureArrayBlastBallEnd, timePerFrame: 0.05), count: 1))
        let explosion = SKSpriteNode( imageNamed : "cat_blast_end_1")
        //let pos = bullet.position
        //let siz = enemyDictionary[object.name!]?.enemy.size
        
        if(facingRight){
            explosion.xScale = 1
            let sequence = SKAction.sequence([anim, buildActionBullet(explosion)])
            explosion.position = bullet.position
            self.addChild(explosion)
            explosion.run(sequence)
            bullet.removeFromParent()
            push = true
            enemyDictionary[object.name!]?.push = true
            enemyDictionary[object.name!]?.hp = (enemyDictionary[object.name!]?.hp)!  - 10
            
        }
        else{
            explosion.xScale = -1
            let sequence = SKAction.sequence([anim, buildActionBullet(explosion)])
            explosion.position = bullet.position
            self.addChild(explosion)
            explosion.run(sequence)
            bullet.removeFromParent()
            push = true
            enemyDictionary[object.name!]?.push = true
            enemyDictionary[object.name!]?.hp = (enemyDictionary[object.name!]?.hp)!  - 10
            
        }
        
        if((enemyDictionary[object.name!]?.hp)! <= 0){
            object.removeFromParent()
            enemyDictionary.removeValue(forKey: object.name!)
            //explodeEnemy(position: pos, size : siz!)
        }
    }
    
    func explodeEnemy(position: CGPoint, size : CGSize){
        let anim = (SKAction.repeat(SKAction.animate(with: self.TextureArrayBlastBallEnd, timePerFrame: 0.05), count: 1))
        let explosion = SKSpriteNode( imageNamed : "cat_blast_end_1")

        explosion.xScale = 1
        let sequence = SKAction.sequence([anim])
        explosion.position = position
        explosion.size = size
        self.addChild(explosion)
        explosion.run(sequence)
        
    }
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        for index in 0...enemyCount {
            if nodeA.name == "bullet" && nodeB.name == "enemy\(index)"{
                collisionBetween(bullet: nodeA, object: nodeB)
            } else if nodeB.name == "bullet"  && nodeA.name == "enemy\(index)" {
                collisionBetween(bullet: nodeB, object: nodeA)
            }
        }
    }

    
    func startTimer(){
        
        var runCount = 0
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                
                runCount += 1
                
                if runCount == 1 {
                    timer.invalidate()
                    self.shootBullets = true
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
