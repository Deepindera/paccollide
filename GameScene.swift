//
//  GameScene.swift
//  paccollide
//
//  Created by Deepindera on 28/06/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
   
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let backgroundNode = SKSpriteNode(imageNamed:"Landing");
        backgroundNode.name = NodeName.Scene.rawValue;
        backgroundNode.size = frame.size;
        backgroundNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        self.addChild(backgroundNode);
        
       

        let debugFrame = SKShapeNode(rectOfSize: backgroundNode.size)
        debugFrame.strokeColor = SKColor.greenColor()
        backgroundNode.addChild(debugFrame)
        
        
        let startbutton = SKSpriteNode(imageNamed:"PlayButton");
        //var position = backgroundNode.convertPoint(backgroundNode.position, fromNode: backgroundNode.parent!);
        startbutton.position = CGPointMake(0,250 - backgroundNode.position.y );
        startbutton.name = NodeName.Start.rawValue;
        backgroundNode.addChild(startbutton);
        
        
        let creditsbutton = SKSpriteNode(imageNamed:"CreditsButton");
        creditsbutton.position = CGPointMake(startbutton.position.x,startbutton.position.y - 70);
        creditsbutton.name = NodeName.Credits.rawValue;
        backgroundNode.addChild(creditsbutton);
        
        
        let factory = Factory();
        
        /*
        var pinkGhost = factory.MakePinkGhost();
        pinkGhost.position = CGPointMake(position.x/2 + 90, 110);
        pinkGhost.runAction(pinkGhost.launchWalkLeft(), withKey: ActionNames.Random.rawValue);
        backgroundNode.addChild(pinkGhost);
        */
        
        let greenGhost = factory.MakeGreenGhost();
        greenGhost.position = CGPointMake(-20, 0);
        greenGhost.runAction(greenGhost.launchWalkRight(), withKey: ActionNames.Random.rawValue);
        backgroundNode.addChild(greenGhost);
        
        if(defaults.valueForKey(defaultsKeys.GameRecord) == nil)
        {
            loadBlankSlateProgressTree();
        }
        
              
    }
    
    
    func dimBackground()
    {
        let backgroundNode: SKSpriteNode = self.childNodeWithName(NodeName.Scene.rawValue) as! SKSpriteNode;
        backgroundNode.alpha = 0.2;
    }
    
    
    func unDimBackground()
    {
        let backgroundNode: SKSpriteNode = self.childNodeWithName(NodeName.Scene.rawValue) as! SKSpriteNode;
        backgroundNode.alpha = 1;
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches ) {
            let location = touch.locationInNode(self);
            
            if(self.nodeAtPoint(location).name == NodeName.Start.rawValue)
            {
                dimBackground();
                
                showProgressTree();
                return;
                
                /*
                //audioplayer?.stop();
                
                */
            }
            

            if self.nodeAtPoint(location).name?.rangeOfString("StageButton") != nil {
                let nodename = self.nodeAtPoint(location).name;
                let stageNumber = nodename!.removeCharsFromStart(11);
                startGameFromStage(Int(stageNumber)!);
                
                return;
            }
            
            
            if(self.nodeAtPoint(location).name == NodeName.Credits.rawValue)
            {
                dimBackground();
                
                showCreditsScene();
                return;
            }
            if(self.nodeAtPoint(location).name == NodeName.Exit.rawValue)
            {
                unDimBackground();
                
                let creditsMenu = (self.childNodeWithName(NodeName.CreditsMenu.rawValue) as SKNode?);
                if(creditsMenu !=  nil)
                {
                    creditsMenu!.removeFromParent();
                }
                
                let progressTreeMenu = (self.childNodeWithName(NodeName.ProgressMenu.rawValue) as SKNode?);
                if(progressTreeMenu !=  nil)
                {
                    progressTreeMenu!.removeFromParent();
                }
                
                
                return;
                
            }
        }
    }
    
    
    func startGameFromStage(stagenumber:Int)
    {
       defaults.setValue(stagenumber, forKey: defaultsKeys.StartStage);
        let secondScene = StageScene(size: self.size)
        let transition = SKTransition.flipVerticalWithDuration(0.5)
        secondScene.scaleMode = SKSceneScaleMode.AspectFill;
        self.scene!.view?.presentScene(secondScene, transition: transition);
    }
    
    
    func showProgressTree()
    {
        let progressTreeMenu = SKSpriteNode(imageNamed: "PlayMenu");
        progressTreeMenu.name = NodeName.ProgressMenu.rawValue;
        progressTreeMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
        let exitButton = SKSpriteNode(imageNamed: "ExitButton");
        exitButton.name = NodeName.Exit.rawValue;
        exitButton.position = CGPointMake(0,-180);
        progressTreeMenu.addChild(exitButton);
        progressTreeMenu.zPosition = 1;
        
        for stagenode in GetGameProgress()
        {
            progressTreeMenu.addChild(stagenode);
        }
       
        
        //56 w x 50 H
        
        self.addChild(progressTreeMenu);
        
        
    }
    
    /*
    func getCurrentGameScore()
    {
       
        if let gameProgressArray = defaults.valueForKey(defaultsKeys.GameRecord) as? [GameProgress] {
           gameProgressArray.count;
        }
        
    }
*/
    
    
    func showCreditsScene()
    {
        let creditsMenu = SKSpriteNode(imageNamed: "Credits");
        creditsMenu.name = NodeName.CreditsMenu.rawValue;
        creditsMenu.position = CGPointMake(self.size.width/2, self.size.height/2);
        let exitButton = SKSpriteNode(imageNamed: "ExitButton");
        exitButton.name = NodeName.Exit.rawValue;
        exitButton.position = CGPointMake(0,-180);
        creditsMenu.addChild(exitButton);
        creditsMenu.zPosition = 1;
        
        
        self.addChild(creditsMenu);
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
