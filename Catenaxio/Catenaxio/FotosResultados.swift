//
//  FotosResultados.swift
//  Catenaxio
//
//  Created by Hugh on 08/08/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation
import UIKit
class FotosResultados: NSObject {
    
    func getImageWithName(_ nombre:String) -> UIImage {
        
        if nombre == "G" {
            return UIImage(named: "victoria")!;
        }
        else if nombre == "P" {
            return UIImage(named: "derrota")!;
            
        }
        else if nombre == "E" {
            return UIImage(named: "empate")!;
            
        }
        
            
        else{
            return UIImage(named: "invitado")!;
        }
        
    }
    
    func getImageColorWithName(_ nombre:String) -> UIColor {
        
        if nombre == "G" {
            return UIColor.green;
        }
        else if nombre == "P" {
            return UIColor.red;
            
        }
        else if nombre == "E" {
            return UIColor.yellow;
            
        }
            
            
        else{
            return UIColor.white;
        }
        
    }
    
}
