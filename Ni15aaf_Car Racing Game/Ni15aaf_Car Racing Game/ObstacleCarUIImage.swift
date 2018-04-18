//
//  ObstacleCarUIImage.swift
//  Ni15aaf_Car Racing Game
//
//  Created by Nana Insaidoo on 18/04/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit

class ObstacleCarUIImage: UIImageView {
    
    override var image: UIImage? {
        didSet{
            if image?.isEqual(UIImage(named: "explosion.png")) == true {
                let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(700)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.removeFromSuperview()
                }
            }
        }
    }

}
