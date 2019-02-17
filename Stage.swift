//
//  Stage.swift
//  paccollide
//
//  Created by Deepindera on 8/07/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation

class Stage
{
    var StageId:Int = 1;
    var StageName:String = "";
    var TimeToLive:Int = 60;
    var Fact:String = "";
    var NumberOfGhosts:Int = 2;
    var SpeedOfGhosts:Int = 1;
    var FloorImage:String = "";
    
    init(id:Int)
    {
        self.StageId = id;
    }
    
}







