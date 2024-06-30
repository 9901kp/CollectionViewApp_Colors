//
//  HexColorsCollectionViewCell.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 22.01.2024.
//

import UIKit

class HexColorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.backgroundColor = UIColor.red
    }
    
    func setup(color: UIColor){
        colorView.backgroundColor = color
    }

}
