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
    
    func getImageWithName(nombre:String) -> UIImage {
        
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
    
    func getImageColorWithName(nombre:String) -> UIColor {
        
        if nombre == "G" {
            return UIColor.greenColor();
        }
        else if nombre == "P" {
            return UIColor.redColor();
            
        }
        else if nombre == "E" {
            return UIColor.yellowColor();
            
        }
            
            
        else{
            return UIColor.whiteColor();
        }
        
    }
    
}