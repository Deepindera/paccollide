//
//  NodeButton.swift
//  paccollide
//
//  Created by Deepindera on 8/07/2015.
//  Copyright (c) 2015 Deepindera. All rights reserved.
//

import Foundation
import SpriteKit

class NodeButton: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action: () -> Void
    
    init(defaultButtonImage: String, activeButtonImage: String, buttonAction: () -> Void) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.hidden = true
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }
    
    /**
    Required so XCode doesn't throw warnings
    */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
  