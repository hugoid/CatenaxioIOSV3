//
//  CatxImagenEstadio.swift
//  Catenaxio
//
//  Created by Hugh on 08/08/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import Foundation
import UIKit

class FotosEstadio: NSObject {
    
    func getImageWithName(nombre:String) -> UIImage {
        print("mi estadio es \(nombre)")
        if nombre == "Juan de la Cierva" {
            return UIImage(named: "cierva")!;
        }
        else if nombre == "Perales" {
            return UIImage(named: "perales")!;
            
        }
        else if nombre == "Sector III" {
            return UIImage(named: "sectorIII")!;
            
        }
        else if nombre == "M-4" {
            return UIImage(named: "m4")!;
            
        }
       
        else if nombre == "El Bercial" {
            return UIImage(named: "bercial")!;
            
        }
        else if nombre == "Giner 1" {
            return UIImage(named: "giner")!;
            
        }
        else if nombre == "Giner 2" {
            return UIImage(named: "giner")!;
            
        }
        
        else{
            return UIImage(named: "invitado")!;
        }
        
    }
    
}