//
//  GroceryTableViewCell.swift
//  RecipeNoteApp
//
//  Created by Julian Sanchez on 2022-05-24.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    //MARK: Outlet
    @IBOutlet weak var groceryNameLbl: UILabel!
    @IBOutlet weak var groceryPhoneLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
