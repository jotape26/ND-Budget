//
//  ExpensesCell.swift
//  Budget
//
//  Created by João Leite on 07/02/19.
//  Copyright © 2019 João Leite. All rights reserved.
//

import UIKit

class ExpensesCell: UITableViewCell {

    @IBOutlet weak var backgroundFromCell: UIView!
    @IBOutlet weak private var expenseText: UILabel!
    @IBOutlet weak var lbExpenseName: UILabel!
    @IBOutlet weak var lbExpenseValue: UILabel!
    @IBOutlet weak var lbDateExpense: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundFromCell.layer.cornerRadius = 3
        expenseText.textColor = APPCOLOR.ORANGE
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
