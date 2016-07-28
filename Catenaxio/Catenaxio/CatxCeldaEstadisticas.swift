//
//  CatxCeldaEstadisticas.swift
//  Catenaxio
//
//  Created by Hugh on 26/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

class CatxCeldaEstadisticas: UITableViewCell {

    
    
    @IBOutlet weak var imageCeldaEstadisticas: UIImageView!
    
    @IBOutlet weak var partidosJugadosCeldaEstadistica: UILabel!
    
    @IBOutlet weak var partidosGanadosCeldaEstadisticas: UILabel!
    
    @IBOutlet weak var golesCeldaEstadisticas: UILabel!
    
    @IBOutlet weak var asistenciasCeldaEstadisticas: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var cellId:String{
        return NSStringFromClass(self);
    }

}
