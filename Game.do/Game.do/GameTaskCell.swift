//
//  GameTaskCell.swift
//  Game.do
//
//  Created by user186880 on 5/27/21.
//

import UIKit

class GameTaskCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var TaskCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(for game: SavedGame){
        if game.title!.isEmpty{
            TitleLabel.text = "(No Title)"
        } else {
            TitleLabel.text = game.title
        }
        print(game.tasks)
        TaskCount.text = String(game.tasks!.count) + " left"
    }
}
