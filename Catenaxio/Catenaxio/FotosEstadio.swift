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
        
        if nombre == "cierva" {
            return UIImage(named: "cierva")!;
        }
        else if nombre == "perales" {
            return UIImage(named: "perales")!;
            
        }
        else if nombre == "sectorIII" {
            return UIImage(named: "sectorIII")!;
            
        }
        else if nombre == "m4" {
            return UIImage(named: "m4")!;
            
        }
       
        else if nombre == "bercial" {
            return UIImage(named: "bercial")!;
            
        }
        else if nombre == "giner" {
            return UIImage(named: "giner")!;
            
        }
        
        else{
            return UIImage(named: "invitado")!;
        }
        
    }
    
}