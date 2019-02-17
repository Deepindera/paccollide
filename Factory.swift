//
//  Factory.swift
//  paccollide
//
//  Created by Deepindera on 29/06/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import QuartzCore

class Factory
{
    var ghostArray:[Ghost];
    
    //Blue
    let textureBlueGhost = "blue_center";
    let textureDownBlueGhost = "blue_down";
    let textureDownBlueGhost_Crash = "blue_down_crash";
    let textureUpBlueGhost = "blue_up";
    let textureUpBlueGhost_Crash = "blue_up_crash";
    let textureLeftBlueGhost = "blue_left";
    let textureLeftBlueGhost_Crash = "blue_left_crash";
    let textureRightBlueGhost = "blue_right";
    let textureRightBlueGhost_Crash = "blue_right_crash";
    //Pink
    let texturePinkGhost = "pink_center";
    let textureDownPinkGhost = "pink_down";
    let textureDownPinkGhost_Crash = "pink_down_crash";
    let textureUpPinkGhost = "pink_up";
    let textureUpPinkGhost_Crash = "pink_up_crash";
    let textureLeftPinkGhost = "pink_left";
    let textureLeftPinkGhost_Crash = "pink_left_crash";
    let textureRightPinkGhost = "pink_right";
    let textureRightPinkGhost_Crash = "pink_right_crash";
    //Green
    let textureGreenGhost = "green_center";
    let textureDownGreenGhost = "green_down";
    let textureDownGreenGhost_Crash = "green_down_crash";
    let textureUpGreenGhost = "green_up";
    let textureUpGreenGhost_Crash = "green_up_crash";
    let textureLeftGreenGhost = "green_left";
    let textureLeftGreenGhost_Crash = "green_left_crash";
    let textureRightGreenGhost = "green_right";
    let textureRightGreenGhost_Crash = "green_right_crash";
    
    init()
    {
        ghostArray = [];
    }
    
    func GetGhosts(total:Int)-> [Ghost]
    {
        ghostArray.removeAll(keepCapacity: false);
        
        for(var index = 0 ; index < total ; index++)
        {
            
            let randomNumber = arc4random_uniform(4);
            
            if(randomNumber == 0)
            {
                ghostArray.append(MakeBlueGhost());
            }
            if(randomNumber == 1)
            {
                ghostArray.append(MakePinkGhost());
            }
            
            if(randomNumber == 2)
            {
                ghostArray.append(MakeGreenGhost());

            }
            if(randomNumber == 3)
            {
                ghostArray.append(MakeBlueGhost());
            }


        }
        return ghostArray;
    }
    
    
    func setPhysics(ghost:Ghost)
    {
        /*var offsetX = ghost.frame.size.width * ghost.anchorPoint.x;
        var offsetY = ghost.frame.size.height * ghost.anchorPoint.y;
        
        var path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, nil, 17 - offsetX, 38 - offsetY);
        CGPathAddLineToPoint(path, nil, 21 - offsetX, 37 - offsetY);
        CGPathAddLineToPoint(path, nil, 30 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, nil, 32 - offsetX, 29 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 26 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path, nil, 34 - offsetX, 22 - offsetY);
        CGPathAddLineToPoint(path, nil, 34 - offsetX, 19 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 16 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 10 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 5 - offsetY);
        CGPathAddLineToPoint(path, nil, 33 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, nil, 32 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 31 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 27 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 24 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 22 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 18 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 14 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 12 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 7 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 26 - offsetY);
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, nil, 2 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 5 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 7 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 27 - offsetY);
        CGPathAddLineToPoint(path, nil, 2 - offsetX, 29 - offsetY);
        CGPathAddLineToPoint(path, nil, 3 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, nil, 5 - offsetX, 33 - offsetY);
        CGPathAddLineToPoint(path, nil, 8 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, nil, 13 - offsetX, 37 - offsetY);
        
        CGPathCloseSubpath(path);
        
        ghost.physicsBody = SKPhysicsBody(polygonFromPath: path);
*/
        ghost.physicsBody = SKPhysicsBody(texture: ghost.texture!,size: ghost.texture!.size());
        ghost.physicsBody!.categoryBitMask = GhostCategory;
        ghost.physicsBody!.dynamic = true;
        ghost.physicsBody!.restitution = 0;
        ghost.physicsBody!.affectedByGravity = false;
        ghost.physicsBody!.collisionBitMask = WallCategory | GhostCategory;
        ghost.physicsBody!.contactTestBitMask = WallCategory | GhostCategory;
        ghost.physicsBody!.usesPreciseCollisionDetection = true;
        ghost.physicsBody!.allowsRotation = false;
        
    }
    
    

    
    func MakeBlueGhost()->Ghost
    {
       
        //let ghost = Ghost(texture: artAtlas.textureNamed(textureBlueGhost));
         let ghost = Ghost(imageNamed: textureBlueGhost);
        ghost.name = NodeName.Ghost.rawValue;
        
        ghost.leftanimtextures = MakeTextureStringIntoSkTextureArray(textureLeftBlueGhost);
        ghost.rightanimtextures = MakeTextureStringIntoSkTextureArray(textureRightBlueGhost);
        ghost.topanimtextures = MakeTextureStringIntoSkTextureArray(textureUpBlueGhost);
        ghost.bottomanimtextures = MakeTextureStringIntoSkTextureArray(textureDownBlueGhost);
        
        return ghost;
    }
    
    
    
    func MakePinkGhost()->Ghost
    {
        let ghost = Ghost(imageNamed: texturePinkGhost);
       // let ghost = Ghost(texture: imageNamed(texturePinkGhost));
        ghost.name = NodeName.Ghost.rawValue;
        
        ghost.leftanimtextures = MakeTextureStringIntoSkTextureArray(textureLeftPinkGhost);
        ghost.rightanimtextures = MakeTextureStringIntoSkTextureArray(textureRightPinkGhost);
        ghost.topanimtextures = MakeTextureStringIntoSkTextureArray(textureUpPinkGhost);
        ghost.bottomanimtextures = MakeTextureStringIntoSkTextureArray(textureDownPinkGhost);
        
        return ghost;
    }
    
    func MakeGreenGhost()->Ghost
    {
        //let ghost = Ghost(texture: artAtlas.textureNamed(textureGreenGhost));
        let ghost = Ghost(imageNamed: textureGreenGhost);
        ghost.name = NodeName.Ghost.rawValue;
      
        ghost.leftanimtextures = MakeTextureStringIntoSkTextureArray(textureLeftGreenGhost);
        ghost.rightanimtextures = MakeTextureStringIntoSkTextureArray(textureRightGreenGhost);
        ghost.topanimtextures = MakeTextureStringIntoSkTextureArray(textureUpGreenGhost);
        ghost.bottomanimtextures = MakeTextureStringIntoSkTextureArray(textureDownGreenGhost);
        
        return ghost;
    }
    
    
    private func MakeTextureStringIntoSkTextureArray(textures:String)->[SKTexture]
    {
        var sktextureArray = [SKTexture]();
        let texturestringArr = textures.characters.split {$0 == " "}.map { String($0) }
        for val:String in texturestringArr
        {
            let skTexture = SKTexture(imageNamed:val);
            sktextureArray.append(skTexture);
        }
        
        return sktextureArray;
    }
    
    
    func GenerateRandomPosition(maxwidth:Int, maxheight: Int)-> CGPoint
    {
        let randomX = randomInRange(100,hi: maxwidth);
        let randomY = randomInRange(100, hi: maxheight);
        let randomPoint = CGPoint(x: randomX, y: randomY);
        return randomPoint;
    }
    
    private func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    
    
    
    func GetStage(id:Int)-> Stage
    {
        if(id == 1)
        {
            let stage:Stage = Stage(id: 1);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorGreen";
            stage.Fact = "Fun Fact\nThe human heart pumps 1.5 \n million gallons of blood a year";
            stage.StageName = "The Beginning";
            stage.TimeToLive = 30;
            
            return stage;
        }
        
        if(id == 2)
        {
            let stage:Stage = Stage(id: 2);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorBlue";
            stage.Fact = "Fun Fact\nA humming bird can flap its wings\n over 5000 times a minute";
            stage.StageName = "Double Time";
            stage.TimeToLive = 10;
            
            return stage;
        }
        
        if(id == 3)
        {
            let stage:Stage = Stage(id: 3);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorGreen";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }
        if(id == 4)
        {
            let stage:Stage = Stage(id: 4);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorGreen";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }
        if(id == 5)
        {
            let stage:Stage = Stage(id: 5);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorGreen";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }
        if(id == 6)
        {
            let stage:Stage = Stage(id: 6);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorBlue";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }
        if(id == 7)
        {
            let stage:Stage = Stage(id: 7);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorBlue";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }

        if(id == 8)
        {
            let stage:Stage = Stage(id: 8);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorBlue";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }

        if(id == 9)
        {
            let stage:Stage = Stage(id: 9);
            stage.NumberOfGhosts = 2;
            stage.SpeedOfGhosts = 3;
            stage.FloorImage = "FloorBlue";
            stage.Fact = "Fun Fact\nThe first Olympics were held in Athens in 1896";
            stage.StageName = "Double Time";
            stage.TimeToLive = 12;
            
            return stage;
        }



       
        return Stage(id: 1);
        
    }
    
    
       
    
}
