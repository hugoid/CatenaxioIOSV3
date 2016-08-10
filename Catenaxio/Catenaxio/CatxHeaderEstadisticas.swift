//
//  CatxHeaderEstadisticas.swift
//  Catenaxio
//
//  Created by Hugh on 26/07/16.
//  Copyright © 2016 Hugh. All rights reserved.
//

import UIKit

class CatxHeaderEstadisticas: UITableViewCell {

    @IBOutlet weak var labelPartidosTotales: UILabel!
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
    
    static var cellHeight: Float {
        return 44;
    }

}
