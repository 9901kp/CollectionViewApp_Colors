//
//  CollectionViewCell.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 13.01.2024.
//

import UIKit

class PaletteCell: UICollectionViewCell {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var palette: ColorPalette?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Метод, вызываемый при нажатии кнопки "Избранное"
    @IBAction func favButtonPressed(_ sender: UIButton) {
        
        // Проверяем, что палитра установлена
        guard let palette else { return }
        
        // Меняем изображение кнопки и статус избранного
        if sender.currentImage == UIImage(systemName: "heart") {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        // Переключаем статус избранного для палитры
        toggleFavorites(palette: palette)
    }
    
    // Метод для переключения статуса избранного у палитры
    func toggleFavorites(palette: ColorPalette) {
        
        var favoritePalette = palette
        print("before toggle: \(favoritePalette.name) is \(favoritePalette.isFavorite)")
        
        // Переключаем значение isFavorite
        favoritePalette.isFavorite.toggle()
        print("after toggle : \(favoritePalette.name) is \(favoritePalette.isFavorite)")
        
        // Обновляем статус избранного в UserDefaults
        updateFavoriteStatus(for: favoritePalette.id, isFavorite: favoritePalette.isFavorite)
        
        print("\(favoritePalette.name) is \(favoritePalette.isFavorite)")
    }
    
    // Метод для обновления статуса избранного в UserDefaults
    func updateFavoriteStatus(for paletteId: String, isFavorite: Bool) {
        let defaults = UserDefaults.standard
        
        // Извлекаем данные о палитрах из UserDefaults
        guard let encodedData = defaults.data(forKey: "colorPaletteKey") else {
            print("No palettes found.")
            return
        }
        
        let decoder = JSONDecoder()
        var palettes: [ColorPalette] = []

        // Декодируем данные в массив палитр
        do {
            palettes = try decoder.decode([ColorPalette].self, from: encodedData)
        } catch {
            print("Failed to decode palettes: \(error)")
            return
        }
        
        // Обновляем статус избранного для нужной палитры
        if let index = palettes.firstIndex(where: { $0.id == paletteId }) {
            palettes[index].isFavorite = isFavorite
            print("Palette \(index) is \(isFavorite) and updated")
        } else {
            print("Palette not found.")
            return
        }
        
        // Перекодируем обновленный массив и сохраняем его в UserDefaults
        let encoder = JSONEncoder()
        do {
            let newEncodedData = try encoder.encode(palettes)
            defaults.set(newEncodedData, forKey: "colorPaletteKey")
            defaults.synchronize()
            print("Palette updated successfully.")
        } catch {
            print("Failed to encode palettes: \(error)")
        }
    }
    
    // Метод для настройки ячейки с данными палитры
    func configure(with palette: ColorPalette) {
        // Устанавливаем первый цвет из палитры как фон для imageView
        imageView.backgroundColor = palette.getColors(hexColors: palette.hexColors).first
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        self.palette = palette
        
        var favPalette = palette
        
        // Получаем статус избранного для палитры из UserDefaults
        let favoriteStatus = UserDefaults.standard.bool(forKey: "favoriteStatus_\(palette.name)")
        print("fav status \(favoriteStatus)")
        
        favPalette.isFavorite = favoriteStatus

        // Устанавливаем изображение кнопки в зависимости от статуса избранного
        let imageName = palette.isFavorite ? "heart.fill" : "heart"
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
