//
//  TableDataCell.swift
//  Engineer.ai_assignment
//
//  Created by Ranjeet on 15/01/20.
//  Copyright © 2020 Ranjeet. All rights reserved.
//

import UIKit

protocol tableCellDelegate {
    func change_switch(index:Int,status:Bool);
}

class TableDataCell: UITableViewCell {
    
    @IBOutlet var viewback: UIView!
    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lblcreated: UILabel!
    @IBOutlet var btnSwitch:UISwitch!
    var delegate:tableCellDelegate? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSwitch.addTarget(self, action:#selector(TableDataCell.categorySwitchValueChanged(_:)), for: .valueChanged)

        // Initialization code
    }
    //Switch value Change
    @objc func categorySwitchValueChanged(_ sender : UISwitch!){
        if sender.isOn {
            self.delegate?.change_switch(index:sender.tag,status:true)
        }
        else {
            self.delegate?.change_switch(index:sender.tag,status:false)

        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
