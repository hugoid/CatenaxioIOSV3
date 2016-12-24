//
//  UIImageView+Utils.swift
//  Catenaxio
//
//  Created by Hugo Izquierdo on 8/7/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation

import UIKit

extension UIImageView {
    
    func roundImage() {
        
        
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
    }
}
