//
//  CatxImagenJugador.swift
//  Catenaxio
//
//  Created by Hugh on 26/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation

class CatxImagenJugador: NSObject {
    func getURLImageForName(name:String) -> String {
        
        if name == "Hugo" {
            return "hugoUrl";
        }
        else if name == "Anton" {
            return "AntonUrl";
        }
        
        else {
            return "xxUrl";
        }
        
    }
}