//
//  Ghost.swift
//  paccollide
//
//  Created by Deepindera on 28/06/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//
import SpriteKit
import Foundation

let GhostCategory   : UInt32 = 0b001;//
let WallCategory : UInt32 = 0b010; //


class Ghost : SKSpriteNode
{
    
    var leftanimtextures:[SKTexture]=[];
    var rightanimtextures:[SKTexture]=[];
    var topanimtextures:[SKTexture]=[];
    var bottomanimtextures:[SKTexture]=[];
    var direction: WalkDirection?;
    var repeatCount :Int16 = 0;
    var identifier:String = NSUUID().UUIDString;
    
    func launchCalculateRepeat() -> Void {
        repeatCount++;
        if(repeatCount > 30)
        {
            repeatCount = 0;
            self.removeActionForKey(ActionNames.Random.rawValue);
            if(self.direction == WalkDirection.Left)
            {
                self.runAction(self.launchWalkRight(), withKey: ActionNames.Random.rawValue);
            }
            else
            {
                self.runAction(self.launchWalkLeft(), withKey: ActionNames.Random.rawValue);
            }
            
        }
    }
    
    func calculateRepeat() -> Void {
        repeatCount++;
        if(repeatCount > 50)
        {
            repeatCount = 0;
            self.removeActionForKey(ActionNames.Random.rawValue);
            self.runAction(self.startRandomWalk(), withKey: ActionNames.Random.rawValue);
        }
    }
    
    
    func launchWalkLeft()->SKAction
    {
        
        self.direction = WalkDirection.Left;
        
        let run_left_anim = SKAction.animateWithTextures(leftanimtextures, timePerFrame: NSTimeInterval(0.1));
        let move_left = SKAction.moveByX((0 - self.speed), y: 0, duration: 0);
        let sequence = SKAction.sequence([run_left_anim,move_left,SKAction.runBlock({ self.launchCalculateRepeat() })]);
        return SKAction.repeatAction(sequence, count:100);
        
    }
    func launchWalkRight()->SKAction
    {
        
        self.direction = WalkDirection.Right;
        let run_right_anim = SKAction.animateWithTextures(rightanimtextures, timePerFrame: NSTimeInterval(0.1));
        let move_right = SKAction.moveByX(self.speed, y: 0, duration: 0.0);
        let sequence = SKAction.sequence([run_right_anim,move_right,SKAction.runBlock({ self.launchCalculateRepeat() })]);
        return SKAction.repeatAction(sequence, count:100);
    }
    
    
    func walkLeft()->SKAction
    {
        if(self.position.x > 50)
        {
            self.direction = WalkDirection.Left;
            
            let run_left_anim = SKAction.animateWithTextures(leftanimtextures, timePerFrame: NSTimeInterval(0.1));
            let move_left = SKAction.moveByX((0 - self.speed), y: 0, duration: 0);
            let sequence = SKAction.sequence([run_left_anim,move_left,SKAction.runBlock({ self.calculateRepeat() })]);
            return SKAction.repeatAction(sequence, count:100);
        }
        else
        {
            
            return walkRight();
        }
        
        
    }
    
    func walkRight()->SKAction
    {
        if(self.position.x < 286)
        {
            self.direction = WalkDirection.Right;
            let run_right_anim = SKAction.animateWithTextures(rightanimtextures, timePerFrame: NSTimeInterval(0.1));
            let move_right = SKAction.moveByX(self.speed, y: 0, duration: 0.0);
            let sequence = SKAction.sequence([run_right_anim,move_right,SKAction.runBlock({ self.calculateRepeat() })]);
            return SKAction.repeatAction(sequence, count:100);
        }
        else
        {
            
            return walkLeft()
        }
        
    }
    
    func walkUp()->SKAction
    {
        
        if(self.position.y < 543)
        {
            self.direction = WalkDirection.Up;
            let run_up_anim = SKAction.animateWithTextures(topanimtextures, timePerFrame: NSTimeInterval(0.1));
            let move_up = SKAction.moveByX(0, y:self.speed, duration: 0.0);
            let sequence = SKAction.sequence([run_up_anim,move_up,SKAction.runBlock({ self.calculateRepeat() })]);
            //return SKAction.repeatActionForever(sequence);
            return SKAction.repeatAction(sequence, count:100);
        }
        else
        {
            
            return walkDown()
        }
        
    }
    
    func walkDown()->SKAction
    {
        if(self.position.y > 50)
        {
            self.direction = WalkDirection.Down;
            let run_down_anim = SKAction.animateWithTextures(bottomanimtextures, timePerFrame: NSTimeInterval(0.1));
            let move_down = SKAction.moveByX(0, y:(0 - self.speed), duration: 0.0);
            let sequence = SKAction.sequence([run_down_anim,move_down,SKAction.runBlock({ self.calculateRepeat() })]);
            return SKAction.repeatAction(sequence, count:100);
            
            //var sequenceD = SKAction.sequence([run_down_anim,move_down,SKAction.runBlock({ self.checkForCollision() })]);
            
            //return SKAction.repeatAction(SKAction.sequence([run_down_anim,move_down]),count:10);
        }
        else
        {
            
            return walkUp()
        }
        
    }
    
    func startRandomWalk()->SKAction
    {
        return getRandomAction();
    }
    
    
    func getRandomAction()->SKAction
    {
        let randomNumber = arc4random_uniform(4);
        
        if(randomNumber == 0)
        {
            return self.walkLeft();
        }
        if(randomNumber == 1)
        {
            return self.walkRight();
        }
        
        if(randomNumber == 2)
        {
            return self.walkDown();
        }
        if(randomNumber == 3)
        {
            return self.walkUp();
        }
        
        return self.walkUp();
    }
    
}
