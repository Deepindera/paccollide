//
//  Enums.swift
//  MiniLookout
//
//  Created by Deepindera on 19/05/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation


enum WalkDirection:Int8{
    case Left = 1;
    case Right = 2;
    case Up = 3;
    case Down = 4;
}

enum NodeName:String
{
    case Ghost =  "Ghost";
    
    case Power =  "Power";
    case Baddie =  "Baddie";
    case Scene = "Scene";
    case Pause = "Pause";
    case Start = "Start";
    case Continue = "Continue";
    case Restart = "Restart";
    case Resume = "Resume";
    case Credits = "Credits";
    case CreditsMenu = "CreditsMenu";
    case Exit = "Exit";
    case LeftHeart = "LeftHeart";
    case CenterHeart = "CenterHeart";
    case RightHeart = "RightHeart";
    case PauseMenu = "PauseMenu";
    case StagePassMenu = "StagePassMenu";
    case GameOverMenu = "GameOverMenu";
    case Star = "Star";
    case FactLabel = "FactLabel";
    case Blur = "Blur";
    case ProgressMenu = "ProgressMenu";
    case StageButton = "StageButton";

}


enum ImageNames:String
{
  case ContinueButton = "ContinueButton";
    
}


enum ActionNames:String
{
    case Left =  "Left";
    case Right =  "Right";
    case Up =  "Up";
    case Down = "Down";
     case Random = "Random";

}


enum WallSide:Int8{
    case Left = 1;
    case Right = 2;
    case Up = 3;
    case Down = 4;
}

