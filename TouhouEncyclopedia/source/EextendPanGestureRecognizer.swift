//
//  SomeCoolPanGestureRecognizer.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/09/02.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class EextendPanGestureRecognizer: UIPanGestureRecognizer {

    private var initialTouchLocation: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
        if  self.state == UIGestureRecognizerState.possible  {
            self.state = UIGestureRecognizerState.changed
        }
    }
}
