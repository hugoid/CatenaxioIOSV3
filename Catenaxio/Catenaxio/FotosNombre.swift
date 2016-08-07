//
//  FotosNombre.swift
//  Catenaxio
//
//  Created by Hugo Izquierdo on 8/7/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation
import UIKit

class FotosNombre: NSObject {
    
    func getImageWithName(nombre:String) -> UIImage {
        
        if nombre == "abel" {
            return UIImage(named: "abel")!;
        }
        else if nombre == "abelD" {
            return UIImage(named: "abelD")!;
        
        }
        else if nombre == "juanito" {
            return UIImage(named: "juanito")!;
            
        }
        else if nombre == "fer" {
            return UIImage(named: "fer")!;
            
        }
        else if nombre == "jordan" {
            return UIImage(named: "jordan")!;
            
        }
        else if nombre == "hector" {
            return UIImage(named: "hector")!;
            
        }
        else if nombre == "juanma" {
            return UIImage(named: "juanma")!;
            
        }
        else if nombre == "hugo" {
            return UIImage(named: "hugo3")!;
            
        }
        else if nombre == "meri" {
            return UIImage(named: "meri")!;
            
        }
        else if nombre == "anton" {
            return UIImage(named: "anton")!;
            
        }
        else{
             return UIImage(named: "invitado")!;
        }
        
    }
    
}