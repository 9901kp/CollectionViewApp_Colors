//
//  FavoriteColorTableViewCell.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 29.01.2024.
//

import UIKit

class FavoriteColorTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Код инициализации ячейки
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Конфигурирование ячейки при выборе
    }
    
    // Метод настройки ячейки с любимым цветом
    func setupFavColor(color: ColorPalette) {
        // Устанавливаем фоновый цвет представления ячейки на первый цвет из палитры
        view.backgroundColor = color.getColors(hexColors: color.hexColors).first
    }
}
