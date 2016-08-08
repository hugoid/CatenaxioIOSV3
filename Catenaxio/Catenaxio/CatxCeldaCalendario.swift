//
//  CatxCeldaCalendario.swift
//  Catenaxio
//
//  Created by Hugh on 19/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

class CatxCeldaCalendario: UITableViewCell {

    
    @IBOutlet weak var horaLabel: UILabel!
    
    @IBOutlet weak var lugarLabel: UILabel!
    
    @IBOutlet weak var rivalLabel: UILabel!
    
    @IBOutlet weak var resultadoLabel: UILabel!
    
    @IBOutlet weak var imagenEstadio: UIImageView!
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
