//
//  DraggableImageView.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 05/04/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit

class DraggableImageView: UIImageView {

    var startLocation: CGPoint?
    var parentClassDelegate: SubViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newcenter: CGPoint = CGPoint(x:self.center.x+dx, y:self.center.y+dy)
        
        // Constrain movement into parent bounds
        let halfx: CGFloat = self.bounds.midX
        newcenter.x = max(halfx, newcenter.x)
        newcenter.x = min(self.superview!.bounds.size.width - halfx, newcenter.x)
        
        let halfy: CGFloat = self.bounds.maxY
        newcenter.y = max(halfy, newcenter.y)
        newcenter.y = min(self.superview!.bounds.size.height - halfy, newcenter.y)
        
        //Set new location
        self.center = newcenter
        
        self.parentClassDelegate?.movePlayersColissionBounds()
    }

}
