//
//  File.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 13.01.2024.
//

import Foundation
import UIKit

// Структура ColorPalette, представляющая палитру цветов
struct ColorPalette: Codable {
    
    let id: String
    let name: String
    let hexColors: [String]
    var isFavorite: Bool
    
    // Инициализатор для структуры ColorPalette
    init(id: String, name: String, hexColors: [String], isFavorite: Bool) {
        self.id = id
        self.name = name
        self.hexColors = hexColors
        self.isFavorite = isFavorite
    }
    
    // Метод для преобразования массива hex-цветов в массив UIColor
    func getColors(hexColors: [String]) -> [UIColor] {
        // Преобразуем каждый hex-цвет в UIColor. Если преобразование не удалось, используем черный цвет
        let colors = hexColors.map { UIColor(hex: $0) ?? UIColor.black }
        return colors
    }
    
    // Пустой метод для изменения статуса избранного (в текущем виде ничего не делает)
    func changeFavorite() {
        // Реализация будет добавлена позже
    }
}

// Расширение для UIColor для добавления инициализатора, который принимает hex-строку
extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        // Проверка на наличие символа "#" в начале строки
        if hex.hasPrefix("#") {
            // Получаем подстроку после символа "#"
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            // Проверяем, что длина hex-строки равна 6 символам
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                // Сканируем hex-строку и преобразуем ее в UInt64
                if scanner.scanHexInt64(&hexNumber) {
                    // Извлекаем компоненты красного, зеленого и синего цветов из hex-значения
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    // Инициализируем UIColor с полученными компонентами
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        // Если hex-строка некорректна, возвращаем nil
        return nil
    }
}
