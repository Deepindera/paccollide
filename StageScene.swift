//
//  StageScene.swift
//  paccollide
//
//  Created by Deepindera on 28/06/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation



class StageScene: SKScene , SKPhysicsContactDelegate {
    var factory =  Factory();
    var touchStartLocation: CGPoint? = nil;
    var touchEndLocation: CGPoint? = nil;
    var touchedGhost: Ghost? = nil;
    var spawnedPositions:[CGPoint] = [CGPoint]();
    var touchDirection:UISwipeGestureRecognizerDirection = UISwipeGestureRecognizerDirection();
    var timeLabel = SKLabelNode(fontNamed: "ScoreLabel");
    var timerLabel = SKLabelNode(fontNamed: "ScoreLabel");
    var timer = NSTimer();
    var background = SKSpriteNode();
    var pause = SKSpriteNode();
    var gameOverMenu = SKSpriteNode();
    var stagePassedMenu = SKSpriteNode();
    var stageStartMenu = SKSpriteNode();
    var ghosts:[Ghost] = [];
    var hitCount = 0;
    var collisionRecorder:[CollisionRecord] = [CollisionRecord]();
    var currentStage: Stage = Stage(id: 1);
    var currentStageId = 1;
    var leftLifeHeart = SKNode();
    var centerLifeHeart = SKNode();
    var rightLifeHeart = SKNode();
    let defaults = NSUserDefaults.standardUserDefaults();

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                NSLog("Swipe Right");
                if(touchedGhost != nil)
                {
                    touchedGhost!.removeAllActions();
                    touchedGhost!.runAction(touchedGhost!.walkRight(), withKey: ActionNames.Random.rawValue);
                }
            case UISwipeGestureRecognizerDirection.Down:
                NSLog("Swipe Down");
                if(touchedGhost != nil)
                {
                    touchedGhost!.removeAllActions();
                    touchedGhost!.runAction(touchedGhost!.walkDown(), withKey: ActionNames.Random.rawValue);
                    
                }
            case UISwipeGestureRecognizerDirection.Up:
                NSLog("Swipe Up");
                if(touchedGhost != nil)
                {
                    touchedGhost!.removeAllActions();
                    touchedGhost!.runAction(touchedGhost!.walkUp(), withKey: ActionNames.Random.rawValue);
                }
            case UISwipeGestureRecognizerDirection.Left:
                NSLog("Swipe Left");
                if(touchedGhost != nil)
                {
                    touchedGhost!.removeAllActions();
                    touchedGhost!.runAction(touchedGhost!.walkLeft(), withKey: ActionNames.Random.rawValue);
                }
            default:
                break
            }
        }
    }
    
    func  distanceBetweenPoints(first:CGPoint, second:CGPoint)-> CGFloat {
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)));
    }
    
    func setSpawnPosition(node:Ghost)
    {
        let newPosition = factory.GenerateRandomPosition(320, maxheight: 568);
        
        var foundSuitablePosition = true;
        
        for pos : CGPoint in spawnedPositions {
            let distance = distanceBetweenPoints(newPosition,second: pos);
            if(distance < 120.0)
            {
                foundSuitablePosition = false;
                break;
                
            }
        }
        
        if( foundSuitablePosition == false )
        {
            setSpawnPosition(node);
            
        }
        else
        {
            spawnedPositions.insert(newPosition, atIndex: spawnedPositions.count);
            node.position =  newPosition;
        }
        
        
    }
    

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view);
        self.physicsWorld.contactDelegate = self;
        self.name = NodeName.Scene.rawValue;
        self.physicsBody=SKPhysicsBody(edgeLoopFromRect: self.frame);
        self.physicsBody!.categoryBitMask = WallCategory;
        self.physicsBody!.collisionBitMask = GhostCategory;
        self.physicsBody!.contactTestBitMask = GhostCategory;
        self.physicsBody!.usesPreciseCollisionDetection = true;
        
        //Swipe Gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view!.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view!.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view!.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp);
      
         self.view!.showsPhysics = true;
        currentStageId = getCurrentGameScore();
        
        
        self.startStage();
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("Touches Ended");
        for touch: AnyObject in touches {
            touchStartLocation = touch.locationInNode(self)
            let anynode  = self.nodeAtPoint(touchStartLocation!);
            if(anynode is Ghost)
            {
                let node = anynode as! Ghost;
                touchedGhost = node;
            }
            
            if(anynode.name == NodeName.Pause.rawValue)
            {
                showPauseMenu();
            }
            
            if(anynode.name == NodeName.Exit.rawValue)
            {
                exitGame();
            }
            
            if(anynode.name == NodeName.Resume.rawValue)
            {
                resumeGame();
            }
            
            if(anynode.name == NodeName.Continue.rawValue)
            {
                startStage();
            }
            
            if(anynode.name == NodeName.Restart.rawValue)
            {
                restartStage();
            }
        }
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA.node!;
        let bodyB = contact.bodyB.node!;
        
        if(bodyA.name != bodyB.name && bodyA.name == NodeName.Scene.rawValue)
        {
            // Ghost collided with Wall
            let nodeB : Ghost = bodyB as! Ghost;
            nodeB.removeActionForKey(ActionNames.Random.rawValue);
            handleGhostandWallCollision(bodyB);
            
        }
        
        if(bodyA.name == bodyB.name && bodyB.name == NodeName.Ghost.rawValue)
        {
            // Ghost collided with Ghost
            let nodeA : Ghost = bodyA as! Ghost;
            let nodeB : Ghost = bodyB as! Ghost;
           
            let timesince1970 = NSDate().timeIntervalSince1970;
            
            if(self.collisionRecorder.count == 0)
            {
                hitCount++;
                updateRemainingLife();
                let collisionRecord:CollisionRecord = CollisionRecord();
                collisionRecord.ghostA = nodeA;
                collisionRecord.ghostB = nodeB;
                collisionRecord.time = timesince1970;
                self.collisionRecorder.insert(collisionRecord, atIndex: 0);
               handleGhostandGhostCollision(nodeA,nodeB: nodeB);
            }
            else
            {
                var lastCollisionHappened5SecondsAgo: Bool = false;
                //var firstCollisionBetweenTwo = true;
                //var indexAtBreak = -1;
                
                let temparray = self.collisionRecorder.sort({$0.time > $1.time});
                NSLog("last collision  happened \(timesince1970 - temparray[0].time)");
                NSLog("hit count is  \(hitCount)");
                
                if((timesince1970 - temparray[0].time) > 1)
                {
                    //indexAtBreak = index;
                    lastCollisionHappened5SecondsAgo = true;
                   // break;
                }


                
                /*
                for (index, cr) in self.collisionRecorder.enumerate() {
                    if((cr.ghostA == nodeB && cr.ghostB == nodeA ) || (cr.ghostA == nodeA && cr.ghostB == nodeB))
                    {
                        NSLog("last collision  happened \(timesince1970 - cr.time)");
                         NSLog("hit count is  \(hitCount)");
                        if((timesince1970 - cr.time) > 4)
                        {
                            indexAtBreak = index;
                            lastCollisionHappened5SecondsAgo = true;
                            break;
                        }
                        else
                        {
                            firstCollisionBetweenTwo = false;
                        }
                        
                    }
                }
*/
                
                
                if(lastCollisionHappened5SecondsAgo)
                {
                    NSLog("lastCollisionHappened5SecondsAgo");
                    hitCount++;
                    if(hitCount > 2)
                    {
                        updateRemainingLife();
                        return stageFailed();
                        
                    }
                    
                    updateRemainingLife();
                    
                    //collisionRecorder.removeAtIndex(indexAtBreak);
                    
                    let collisionRecord:CollisionRecord = CollisionRecord();
                    collisionRecord.ghostA = nodeA;
                    collisionRecord.ghostB = nodeB;
                    collisionRecord.time = timesince1970;
                    collisionRecorder.insert(collisionRecord, atIndex: collisionRecorder.count);
                    handleGhostandGhostCollision(nodeA,nodeB: nodeB);
                }
                else
                {
                    handleGhostandGhostCollision(nodeA,nodeB: nodeB);
                }
                
            }
        }
    }
    
    func handleGhostandGhostCollision(nodeA:Ghost, nodeB:Ghost)
    {
        NSLog("Handle Ghost and GhostCollision");
        
        nodeA.removeActionForKey(ActionNames.Random.rawValue);
        nodeA.repeatCount = 0;
        nodeB.removeActionForKey(ActionNames.Random.rawValue);
        nodeB.repeatCount = 0;
        
        if(nodeA.direction == WalkDirection.Left && nodeB.direction == WalkDirection.Left)
        {
           nodeA.runAction(nodeA.walkUp(), withKey: ActionNames.Random.rawValue);
           nodeB.runAction(nodeB.walkDown(), withKey: ActionNames.Random.rawValue);
            return;
        }
        
        if(nodeA.direction == WalkDirection.Right && nodeB.direction == WalkDirection.Right)
        {
            nodeA.runAction(nodeA.walkUp(), withKey: ActionNames.Random.rawValue);
            nodeB.runAction(nodeB.walkDown(), withKey: ActionNames.Random.rawValue);
            return;
        }
        
        if(nodeA.direction == WalkDirection.Up && nodeB.direction == WalkDirection.Up)
        {
            nodeA.runAction(nodeA.walkLeft(), withKey: ActionNames.Random.rawValue);
            nodeB.runAction(nodeB.walkRight(), withKey: ActionNames.Random.rawValue);
            return;
        }
        
        if(nodeA.direction == WalkDirection.Down && nodeB.direction == WalkDirection.Down)
        {
            nodeA.runAction(nodeA.walkLeft(), withKey: ActionNames.Random.rawValue);
            nodeB.runAction(nodeB.walkRight(), withKey: ActionNames.Random.rawValue);
            return;
        }
    
        switch nodeA.direction!{
        case WalkDirection.Left:
            nodeA.runAction(nodeA.walkRight(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Right:
            nodeA.runAction(nodeA.walkLeft(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Up:
            nodeA.runAction(nodeA.walkDown(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Down:
            nodeA.runAction(nodeA.walkUp(), withKey: ActionNames.Random.rawValue);
        }
        
        switch nodeB.direction!{
        case WalkDirection.Left:
            nodeB.runAction(nodeB.walkRight(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Right:
            nodeB.runAction(nodeB.walkLeft(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Up:
            nodeB.runAction(nodeB.walkDown(), withKey: ActionNames.Random.rawValue);
        case WalkDirection.Down:
            nodeB.runAction(nodeB.walkUp(), withKey: ActionNames.Random.rawValue);
        }
        
        
    }
    
    func handleGhostandWallCollision(sknode:SKNode)
    {
        NSLog("Handle Ghost and Wall Collision");
        
        let node : Ghost = sknode as! Ghost;
        
        if(node.position.y > self.size.height/2)// Bottom side of screen
        {
            //check horizontal side
            if(node.position.x < self.size.width/2)//left half of screen
            {
                //node.runAction(node.walkRight(), withKey: ActionNames.Random.rawValue);
                node.runAction(node.getRandomAction(), withKey: ActionNames.Random.rawValue);
            }
            else
            {
                //node.runAction(node.walkLeft(), withKey: ActionNames.Random.rawValue);
                node.runAction(node.getRandomAction(), withKey: ActionNames.Random.rawValue);
            }
        }
        else // Top side  of screen
        {
            //check horizontal side
            if(node.position.x < self.size.width/2)//left half of screen
            {
                //node.runAction(node.walkDown(), withKey: ActionNames.Random.rawValue);
                node.runAction(node.getRandomAction(), withKey: ActionNames.Random.rawValue);
            }
            else
            {
                //node.runAction(node.walkUp(), withKey: ActionNames.Random.rawValue);
                node.runAction(node.getRandomAction(), withKey: ActionNames.Random.rawValue);
            }
        }
    }
    
    func showBackGround(image:String)     {
        background.removeFromParent();
        background = SKSpriteNode(imageNamed: image);
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        background.size = self.scene!.size;
        self.addChild(background);
    }
    
    func showPauseButton()     {
        pause.removeFromParent();
        pause = SKSpriteNode(imageNamed: "pause");
        pause.name = NodeName.Pause.rawValue;
        pause.position = CGPointMake(12, CGFloat(frame.size.height - 12.0));
        self.addChild(pause);
    }
    
    func showGameOver()     {

        self.removeAllChildren();
        NSLog("Stage Failed");
        
        timer.invalidate();
        
        gameOverMenu = SKSpriteNode(imageNamed: "GameOver");
        gameOverMenu.name = NodeName.GameOverMenu.rawValue;
        gameOverMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
        gameOverMenu.size = self.scene!.size;
        
        let restartButton = SKSpriteNode(imageNamed: "RestartButton");
        restartButton.name = NodeName.Restart.rawValue;
        restartButton.position = CGPointMake(0,-90);
        gameOverMenu.addChild(restartButton);
        
        let exitButton = SKSpriteNode(imageNamed: "ExitButton");
        exitButton.name = NodeName.Exit.rawValue;
        exitButton.position = CGPointMake(0,-150);
        gameOverMenu.addChild(exitButton);

        
        
        self.addChild(gameOverMenu);
        
    }

    func showPauseMenu()     {
        pauseGame();
     
        let pauseMenu = SKSpriteNode(imageNamed: "GamePaused");
        pauseMenu.name = NodeName.PauseMenu.rawValue;
        pauseMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        
        let resumeButton = SKSpriteNode(imageNamed: "ResumeButton");
        resumeButton.name = NodeName.Resume.rawValue;
        resumeButton.position = CGPointMake(0,-30);
        pauseMenu.addChild(resumeButton);
        
        
        let restartButton = SKSpriteNode(imageNamed: "RestartButton");
        restartButton.name = NodeName.Restart.rawValue;
        restartButton.position = CGPointMake(0,-90);
        pauseMenu.addChild(restartButton);
        
        let exitButton = SKSpriteNode(imageNamed: "ExitButton");
        exitButton.name = NodeName.Exit.rawValue;
        exitButton.position = CGPointMake(0,-150);
        pauseMenu.addChild(exitButton);
        
        
        self.addChild(pauseMenu);
    }
    
    func updateRemainingLife()
    {
        if(hitCount == 1)
        {
            rightLifeHeart.removeFromParent();
            rightLifeHeart = SKSpriteNode(imageNamed: "heart_empty");
            rightLifeHeart.position = CGPointMake(90, CGFloat(frame.size.height - 12.0));
            self.addChild(rightLifeHeart);
        }
        if(hitCount == 2)
        {
            centerLifeHeart.removeFromParent();
            centerLifeHeart = SKSpriteNode(imageNamed: "heart_empty");
            centerLifeHeart.position = CGPointMake(65, CGFloat(frame.size.height - 12.0));
            self.addChild(centerLifeHeart);
            
        }
        if(self.hitCount == 3)
        {
            leftLifeHeart.removeFromParent();
            leftLifeHeart = SKSpriteNode(imageNamed: "heart_empty");
            leftLifeHeart.position = CGPointMake(40, CGFloat(frame.size.height - 12.0));
            self.addChild(leftLifeHeart);
            
        }
    }
    
    func showRemainingLife()
    {
        leftLifeHeart.removeFromParent();
        centerLifeHeart.removeFromParent();
        rightLifeHeart.removeFromParent();
        leftLifeHeart = SKSpriteNode(imageNamed: "heart_filled");
        leftLifeHeart.name = NodeName.LeftHeart.rawValue;
        leftLifeHeart.position = CGPointMake(40, CGFloat(frame.size.height - 12.0));
        centerLifeHeart = SKSpriteNode(imageNamed: "heart_filled");
        centerLifeHeart.position = CGPointMake(65, CGFloat(frame.size.height - 12.0));
        centerLifeHeart.name = NodeName.CenterHeart.rawValue;
        rightLifeHeart = SKSpriteNode(imageNamed: "heart_filled");
        rightLifeHeart.position = CGPointMake(90, CGFloat(frame.size.height - 12.0));
        rightLifeHeart.name = NodeName.RightHeart.rawValue;
        self.addChild(leftLifeHeart);
        self.addChild(centerLifeHeart);
        self.addChild(rightLifeHeart);
    }
    
    func showTimer()     {
        timerLabel.removeFromParent();
        timeLabel.removeFromParent();
        
        timerLabel.name = "timerLabelName";
        timerLabel.fontName="ChalkboardSE-Bold";
        timerLabel.fontSize = 15;
        timerLabel.fontColor = SKColor.whiteColor();
        timerLabel.text = "Stage \(currentStage.StageId) Time";
        timerLabel.position = CGPointMake(frame.size.width-85, CGFloat(frame.size.height - 17.0));
        timeLabel.name = "timeLabelName";
        timeLabel.fontName="ChalkboardSE-Bold";
        timeLabel.fontSize = 15;
        timeLabel.fontColor = SKColor.whiteColor();
        timeLabel.position = CGPointMake(frame.size.width - 19, CGFloat(frame.size.height - 17.0));
        
        self.addChild(timeLabel);
        self.addChild(timerLabel);
    }
    
    func startTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimeRemaining"), userInfo: nil, repeats: true)
    }
    
    
    
    func exitGame()
    {
        self.removeAllChildren();
        
        let mainScene = GameScene(size: self.size)
        let transition = SKTransition.flipVerticalWithDuration(0.5)
        mainScene.scaleMode = SKSceneScaleMode.AspectFill;
        self.scene!.view?.presentScene(mainScene, transition: transition)
    }
    
    func pauseGame()
    {
        timer.invalidate()
        for node : Ghost in ghosts {
            node.paused = true;
        }
        
        pause.removeFromParent();
    }
    
    func resumeGame()
    {
        showPauseButton();
        
        startTimer();
        
        let pauseMenu: SKSpriteNode = self.childNodeWithName(NodeName.PauseMenu.rawValue) as! SKSpriteNode;
        
        pauseMenu.removeFromParent();
        
        for node : Ghost in ghosts {
            node.paused = false;
        }
    }

    
    func stagePassed()
    {
        self.scene!.paused = true;
        
        for node : Ghost in ghosts {
            node.removeFromParent();
        }
        
        showStagePassed();
        
    }
    
    func showStagePassed()
    {
        

        stagePassedMenu = SKSpriteNode(imageNamed: "StagePassed");
        stagePassedMenu.name = NodeName.StagePassMenu.rawValue;
        stagePassedMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
        stagePassedMenu.size = self.scene!.size;
        
        
        let starOne = SKSpriteNode(imageNamed: "StarOn");
        starOne.name = NodeName.Star.rawValue;
        starOne.position = CGPointMake(-70,150);
        
        
        let starTwo = SKSpriteNode(imageNamed: "StarOn");
        starTwo.name = NodeName.Star.rawValue;
        starTwo.position = CGPointMake(0,150);
       
        
        
        let starThree = SKSpriteNode(imageNamed: "StarOn");
        starThree.name = NodeName.Star.rawValue;
        starThree.position = CGPointMake(70,150);
        
        
        let starEmptyOne = SKSpriteNode(imageNamed: "StarOff");
        starEmptyOne.name = NodeName.Star.rawValue;
        starEmptyOne.position = CGPointMake(70,150);
       
        
        
        let starEmptyTwo = SKSpriteNode(imageNamed: "StarOff");
        starEmptyTwo.name = NodeName.Star.rawValue;
        starEmptyTwo.position = CGPointMake(0,150);
        
        
        
        if(self.hitCount == 2)
        {
            stagePassedMenu.addChild(starOne);
            stagePassedMenu.addChild(starEmptyOne);
            stagePassedMenu.addChild(starEmptyTwo);
            
        }
        
        if(self.hitCount == 1)
        {
            stagePassedMenu.addChild(starOne);
            stagePassedMenu.addChild(starTwo);
            stagePassedMenu.addChild(starEmptyOne);
        }
        
        if(self.hitCount == 0)
        {
            stagePassedMenu.addChild(starOne);
            stagePassedMenu.addChild(starTwo);
            stagePassedMenu.addChild(starThree);
        }

        
        
        let continueButton = SKSpriteNode(imageNamed: "ContinueButton");
        continueButton.name = NodeName.Continue.rawValue;
        continueButton.position = CGPointMake(0,-30);
        stagePassedMenu.addChild(continueButton);
        
        
        let restartButton = SKSpriteNode(imageNamed: "RestartButton");
        restartButton.name = NodeName.Restart.rawValue;
        restartButton.position = CGPointMake(0,-90);
        stagePassedMenu.addChild(restartButton);
        
        let exitButton = SKSpriteNode(imageNamed: "ExitButton");
        exitButton.name = NodeName.Exit.rawValue;
        exitButton.position = CGPointMake(0,-150);
        stagePassedMenu.addChild(exitButton);
        
        
        let factLabel:NORLabelNode = NORLabelNode();
        factLabel.fontName = "ChalkboardSE-Bold";
        factLabel.text = currentStage.Fact;
        factLabel.fontSize = 13;
        factLabel.fontColor = SKColor.purpleColor();
        factLabel.position = CGPointMake(0,-250);
        factLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        stagePassedMenu.addChild(factLabel);
        
        self.addChild(stagePassedMenu);
        
        updateGameScore();
    }
    
    
    
    func getCurrentGameScore()->Int
    {
        return GetMostRecentPlayableStageNumber();
    }
    
    
    func updateGameScore()
    {
        UpdateGameProgress(hitCount, currentStageId: currentStageId);
        
    }
    
    

    
    
    func restartStage()
    {
        collisionRecorder = [];
        self.hitCount = 0;
        
        if let pauseMenu = self.childNodeWithName(NodeName.PauseMenu.rawValue) as? SKSpriteNode {
            pauseMenu.removeFromParent();
        }
        
        if let stagePassMenu = self.childNodeWithName(NodeName.StagePassMenu.rawValue) as? SKSpriteNode {
            stagePassMenu.removeFromParent();
        }
        
        if let gameoverMenu = self.childNodeWithName(NodeName.GameOverMenu.rawValue) as? SKSpriteNode {
            gameoverMenu.removeFromParent();
        }
        
    
        timer.invalidate();
        for node : Ghost in ghosts {
            node.removeFromParent();
        }
        
        //currentStageId = currentStageId - 1;
        startStage();
        
    }
    
    func startStage()
    {
        self.hitCount = 0;
        
        stagePassedMenu.removeFromParent();
        currentStage =  factory.GetStage(currentStageId);
        //currentStageId = currentStageId + 1;
        

        for node : Ghost in ghosts {
            node.removeFromParent();
        }
        
        showBackGround(currentStage.FloorImage);
        showPauseButton();
        showRemainingLife();
        
        spawnedPositions.removeAll(keepCapacity: false);
        ghosts.removeAll(keepCapacity: false);
        
        
        
        ghosts = factory.GetGhosts(currentStage.NumberOfGhosts);
        
        for ghost : Ghost in ghosts {
            setSpawnPosition(ghost);
            ghost.speed = CGFloat(currentStage.SpeedOfGhosts);
            factory.setPhysics(ghost);
            scene?.addChild(ghost);
            ghost.runAction(ghost.getRandomAction(), withKey: ActionNames.Random.rawValue);
            
        }
        
        self.showTimer();
        timeLabel.text = String(currentStage.TimeToLive);
        
        self.scene!.paused = false;
        self.startTimer();
        
    }
    
    func stageFailed()
    {
        
        showGameOver();
        /*
        delay(3.seconds)
        {
        self.gameover.removeFromParent();
        self.addChild(self.gameover);
        }
        */
        
    }
    
    func updateTimeRemaining()
    {
        var remainingNum = Int(timeLabel.text!);
        if(remainingNum > 0)
        {
            remainingNum! = remainingNum! - 1;
            timeLabel.text = String(remainingNum!);
        }
        else
        {
            timer.invalidate();
            if(self.hitCount == 3)
            {
                stageFailed();
            }
            else
            {
                stagePassed();
            }
            
           
        }
    }
    
}// End of Class