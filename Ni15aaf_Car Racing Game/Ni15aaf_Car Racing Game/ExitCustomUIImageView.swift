//
//  ExitCustomUIImageView.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 06/04/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit

class ExitCustomUIImageView: UIImageView {

    private var _parentView: UIView?
    
    override init(image: UIImage?) {
        super.init(image: image)
        _parentView = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _parentView = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _parentView = nil
    }
    
    init(frame: CGRect, parentView: UIView) {
        super.init(frame: frame)
        _parentView = parentView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _parentView!.removeFromSuperview()
    }

}
