//
//  CorneredButtons.swift
//  TakeMyMoney
//
//  Created by ioannis giannakidis on 28/9/21.
//

import UIKit

class CorneredButtons: UIButton {

    override  func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }

}
