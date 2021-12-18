//
//  GameCell.swift
//  Game.do
//
//  Created by user186880 on 5/12/21.
//

import UIKit

class GameCell: UITableViewCell {

    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for game: SavedGame){
        if game.summary!.isEmpty{
            descLabel.text = "(No Description)"
        } else {
            descLabel.text = game.summary
        }
        
        if game.title!.isEmpty{
            titleLabel.text = "(No Title)"
        } else {
            titleLabel.text = game.title
        }
        
        coverImageView.image = UIImage(data: game.image ?? Data())
    }

}

