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
        
        if nombre == "Abel" {
            return UIImage(named: "abel")!;
        }
        else if nombre == "Dorado" {
            return UIImage(named: "abelD")!;
        
        }
        else if nombre == "Juanito" {
            return UIImage(named: "juanito")!;
            
        }
        else if nombre == "Fer" {
            return UIImage(named: "fer")!;
            
        }
        else if nombre == "Jordan" {
            return UIImage(named: "jordan")!;
            
        }
        else if nombre == "Hector" {
            return UIImage(named: "hector")!;
            
        }
        else if nombre == "Juanma" {
            return UIImage(named: "juanma")!;
            
        }
        else if nombre == "Hugo" {
            return UIImage(named: "hugo3")!;
            
        }
        else if nombre == "Meri" {
            return UIImage(named: "meri")!;
            
        }
        else if nombre == "Anton" {
            return UIImage(named: "anton")!;
            
        }
        else{
             return UIImage(named: "invitado")!;
        }
        
    }
    
}