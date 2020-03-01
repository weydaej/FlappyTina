//
//  GameScene.swift
//  FlappyTina
//
//  Created by Emily Weyda on 7/29/16.
//  Copyright (c) 2016 Emily Weyda. All rights reserved.
//

import SpriteKit

struct physicsCat {
    static let tina : UInt32 = 0x1 << 1
    static let ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var tina = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var score = Int()
    let scoreLbl = SKLabelNode()
    var died = Bool()
    var restartBTN = SKSpriteNode()
    var tapAnywhere = SKLabelNode()
    
    func restartScene(){
    
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene(){
        
        tapAnywhere.alpha = 1
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "background")
            background.anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            background.name = "background"
            self.addChild(background)
        }
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "Futura"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 40
        self.addChild(scoreLbl)
        
        tapAnywhere.position = CGPoint(x: self.frame.width / 2, y: 0 + 80)
        tapAnywhere.text = "\("Tap Anywhere to Begin!")"
        tapAnywhere.fontName = "Avenir Next"
        tapAnywhere.fontSize = 17
        tapAnywhere.zPosition = 6
        self.addChild(tapAnywhere)
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.categoryBitMask = physicsCat.ground
        ground.physicsBody?.collisionBitMask = physicsCat.tina
        ground.physicsBody?.contactTestBitMask = physicsCat.tina
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.dynamic = false
        
        ground.zPosition = 3
        
        self.addChild(ground)
        
        tina = SKSpriteNode(imageNamed: "tina")
        tina.size = CGSize(width: 70, height: 70)
        tina.position = CGPoint(x: self.frame.width / 2 - tina.frame.width, y: self.frame.height / 2)
        tina.physicsBody = SKPhysicsBody(circleOfRadius: tina.frame.height / 2)
        tina.physicsBody?.categoryBitMask = physicsCat.tina
        tina.physicsBody?.collisionBitMask = physicsCat.tina | physicsCat.Wall
        tina.physicsBody?.contactTestBitMask = physicsCat.tina | physicsCat.Wall | physicsCat.score
        tina.physicsBody?.affectedByGravity = false
        tina.physicsBody?.dynamic = true
        
        tina.zPosition = 2
        
        self.addChild(tina)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        createScene()
        
    }
    
    func createBTN(){
    
        restartBTN = SKSpriteNode(imageNamed: "restart")
        restartBTN.size = CGSizeMake(200, 100)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        
        self.addChild(restartBTN)
        
        restartBTN.runAction(SKAction.scaleTo(1.0, duration: 0.3))
    
    }
    func updateStats(){
        // get reference to teh standard transfer user defailse.
        let defaults = NSUserDefaults.standardUserDefaults()
        // 1. get highest score from above
        var highestScore = defaults.integerForKey("HighestScore")
        var currentScore = defaults.integerForKey("CurrentScore")
        var numberOfGames = defaults.integerForKey("NumberOfGames")
        var lowestScore = defaults.integerForKey("LowestScore")
        // 2. compare score by higher store to the highest
        if(score > highestScore)
            // 2.1 if sore is higher update highest score
        {
            highestScore = score
        }
        // update current score
        currentScore = score
        // update # of games
        numberOfGames += 1
        if(score < lowestScore){
            lowestScore = score
        }
        if(numberOfGames == 1){
            lowestScore = score
        }
        // 3 save
        defaults.setInteger(highestScore, forKey: "HighestScore")
        defaults.setInteger(currentScore, forKey: "CurrentScore")
        defaults.setInteger(numberOfGames, forKey: "NumberOfGames")
        defaults.setInteger(lowestScore, forKey: "LowestScore")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == physicsCat.score && secondBody.categoryBitMask == physicsCat.tina{
        
            score+=1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
        
        else if firstBody.categoryBitMask == physicsCat.tina && secondBody.categoryBitMask == physicsCat.score{
            
            score+=1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
            
        }
        
        else if firstBody.categoryBitMask == physicsCat.tina && secondBody.categoryBitMask == physicsCat.Wall || firstBody.categoryBitMask == physicsCat.Wall && secondBody.categoryBitMask == physicsCat.tina{
        
            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                updateStats()
                createBTN()
            }
        }
        else if firstBody.categoryBitMask == physicsCat.tina && secondBody.categoryBitMask == physicsCat.ground || firstBody.categoryBitMask == physicsCat.ground && secondBody.categoryBitMask == physicsCat.tina{
            
            
            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if died == false{
                died = true
                updateStats()
                createBTN()
            }
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        tapAnywhere.alpha = 0

        if gameStarted == false{
            
            gameStarted = true
            
            tina.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock ({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.waitForDuration(2.0)
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance - 50, y: 0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            tina.physicsBody?.velocity = CGVectorMake(0, 0)
            tina.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            
        } else {
            
            if died == true {
                
            } else {
            
                tina.physicsBody?.velocity = CGVectorMake(0, 0)
                tina.physicsBody?.applyImpulse(CGVectorMake(0, 90))
                updateStats()
            }
        }
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if died == true{
                if restartBTN.containsPoint(location){
                    restartScene()
                    updateStats()
                }
            }
        }
    }
    
    func createWalls() {
        
        let scoreNode = SKSpriteNode(imageNamed: "burger")
        
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = physicsCat.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = physicsCat.tina
        scoreNode.color = SKColor.blueColor()
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "wall")
        let btmWall = SKSpriteNode(imageNamed: "wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 365)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 365)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = physicsCat.Wall
        topWall.physicsBody?.collisionBitMask = physicsCat.tina
        topWall.physicsBody?.contactTestBitMask = physicsCat.tina
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = physicsCat.Wall
        btmWall.physicsBody?.collisionBitMask = physicsCat.tina
        btmWall.physicsBody?.contactTestBitMask = physicsCat.tina
        btmWall.physicsBody?.dynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}
