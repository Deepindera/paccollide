//
//  GameProgress.swift
//  paccollide
//
//  Created by Deepindera on 21/08/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation

let defaults = NSUserDefaults.standardUserDefaults();


//returns all shape nodes of game stages
func GetGameProgress()->[SKShapeNode]
{
    var resultShapeArray = [SKShapeNode]();
    
    let data: NSData = (defaults.valueForKey(defaultsKeys.GameRecord) as? NSData)!;
    
    let gameProgressArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [GameProgress];
    
    for progress in gameProgressArray
    {
        let shape = getProgressForStage(progress.StageNumber, stars: progress.Stars, locked: progress.Locked)
        resultShapeArray.append(shape);
        
    }
    
    
    return resultShapeArray;
    
}

// set defaults gameprogress values . Nothing to do with shape nodes
func loadBlankSlateProgressTree()
{
   
        defaults.setValue(nil, forKey: defaultsKeys.GameRecord);
        
        let gameRecord: AnyObject? =  defaults.valueForKey(defaultsKeys.GameRecord) ;
        
        if(gameRecord == nil)
        {
            var gameProgressArray = [GameProgress]();
            
            gameProgressArray.append(GameProgress(StageNumber: 1,Stars: 0,Locked: false ));
            gameProgressArray.append(GameProgress(StageNumber: 2, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress( StageNumber: 3, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 4, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 5, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 6, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 7, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 8, Stars: 0, Locked:true ));
            gameProgressArray.append(GameProgress(StageNumber: 9, Stars: 0, Locked:true ));
            
            
            let gameNSData:NSData = NSKeyedArchiver.archivedDataWithRootObject(gameProgressArray);
            
            defaults.setValue(gameNSData, forKey: defaultsKeys.GameRecord);
    }
    
}


// returns one shape node for one stage
func getProgressForStage(stageNumber:Int, stars:Int)->SKShapeNode
{
    return getProgressForStage(stageNumber,stars: stars,locked: stars==0);
}


func getProgressForStage(stageNumber:Int, stars:Int, locked:Bool)->SKShapeNode
{
    let stageProgressSquare = SKShapeNode(rectOfSize:CGSizeMake(56, 50));
    stageProgressSquare.name = "StageButton\(stageNumber)";
    stageProgressSquare.lineWidth = 0;
    

    let stars = SKSpriteNode(imageNamed: "awardstar_\(stars)");
    stars.setScale(0.5);
    stars.position = CGPointMake(0,-16);

    
    let stageLabel:SKLabelNode = SKLabelNode();
    stageLabel.fontName = "ChalkboardSE-Bold";
    stageLabel.text = String(stageNumber);
    stageLabel.fontSize = 34;
    stageLabel.fontColor = SKColor.whiteColor();
    stageLabel.position = CGPointMake(0,-5);
    stageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
    
    if(stageNumber == 1)
    {
        stageProgressSquare.position = CGPointMake(-74, 82);
    }
    if(stageNumber == 2)
    {
        stageProgressSquare.position = CGPointMake(0, 82);
    }
    if(stageNumber == 3)
    {
        stageProgressSquare.position = CGPointMake(74, 82);
    }
    if(stageNumber == 4)
    {
        stageProgressSquare.position = CGPointMake(-74, -5);
    }
    if(stageNumber == 5)
    {
        stageProgressSquare.position = CGPointMake(0, -5);
    }
    if(stageNumber == 6)
    {
        stageProgressSquare.position = CGPointMake(74, -5);
    }
    if(stageNumber == 7)
    {
        stageProgressSquare.position = CGPointMake(-74, -88);
    }
    if(stageNumber == 8)
    {
        stageProgressSquare.position = CGPointMake(0, -88);
    }
    if(stageNumber == 9)
    {
        stageProgressSquare.position = CGPointMake(74, -88);
    }

   

    
    if(locked == true)
    {
        let lock = SKSpriteNode(imageNamed: "locked");
        lock.position = CGPointMake(-18,18);
        stageProgressSquare.name = "";
        stageProgressSquare.addChild(lock);
    }
    else
    {
        stageLabel.name = "StageButton\(stageNumber)";
        stars.name = "StageButton\(stageNumber)";
    }
    
     stageProgressSquare.addChild(stageLabel);
     stageProgressSquare.addChild(stars);
    
    return stageProgressSquare;
    
}





func UpdateGameProgress(hitCount:Int, currentStageId:Int)
{
    let data: NSData = (defaults.valueForKey(defaultsKeys.GameRecord) as? NSData)!;
    
    var gameProgressArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [GameProgress];
    
    
    let foundStage = gameProgressArray.filter { $0.StageNumber == currentStageId};
    
    if(foundStage.count > 0)
    {
        let indexOne = gameProgressArray.indexOf(foundStage.first!);
        
        gameProgressArray[indexOne!].Stars = 3 -  hitCount;
        gameProgressArray[indexOne!].Locked = false;
        
        
        //foundStage.first!.Stars = 3 -  hitCount;
        //foundStage.first!.Locked = false;
        
        if(hitCount < 3)
        {
            let unlockNextStage = gameProgressArray.filter { $0.StageNumber == currentStageId + 1};
            if(unlockNextStage.count > 0)
            {
                //let indexTwo = gameProgressArray.indexOf(unlockNextStage.first!);
                
                //gameProgressArray[indexTwo!].Locked = false;
                
                

                unlockNextStage.first!.Locked = false;
            }

        }
    }
    else
    {
        let gameProgress = GameProgress(StageNumber: currentStageId, Stars: 3 - hitCount, Locked:false );
        gameProgressArray.append(gameProgress);
    }
    
    let gameNSData:NSData = NSKeyedArchiver.archivedDataWithRootObject(gameProgressArray);
    
    defaults.setValue(gameNSData, forKey: defaultsKeys.GameRecord);
   
   }


func GetMostRecentPlayableStageNumber()->Int
{
    let data: NSData = (defaults.valueForKey(defaultsKeys.GameRecord) as? NSData)!;
    
    let gameProgressArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [GameProgress];
    
    let lastUnlockedStage = gameProgressArray.filter{ $0.Locked == false }.sort { $0.StageNumber > $1.StageNumber};
    
    return lastUnlockedStage.first!.StageNumber;
    
}





