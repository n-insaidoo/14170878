//
//  InformationCustomUIImageView.swift
//  Ni15aaf_Car Racing Game
//
//  Created by ni15aaf on 06/04/2018.
//  Copyright © 2018 ni15aaf. All rights reserved.
//

import UIKit

class InformationCustomUIImageView: UIImageView {

    var parentClassDelegate: SubViewDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentClassDelegate?.showInformationView()
    }

}
