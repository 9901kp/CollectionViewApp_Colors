//
//  ViewController.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 12.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    let itemsPerRow: CGFloat = 3 // Количество элементов в ряду
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 10.0, right: 5.0) // Отступы для секции коллекции
  
    @IBOutlet weak var collectionView: UICollectionView! // Подключение UICollectionView из интерфейса
    
    var palettes: [ColorPalette] = [
        ColorPalette(id: "1", name: "Sunny Day", hexColors: ["#FFD700", "#FFA500", "#FF8C00"], isFavorite: true),
        ColorPalette(id: "2", name: "Ocean Breeze", hexColors: ["#00BFFF", "#1E90FF", "#0000CD"], isFavorite: true),
        ColorPalette(id: "3", name: "Forest Hike", hexColors: ["#228B22", "#008000", "#006400"], isFavorite: false),
        ColorPalette(id: "4", name: "Pastel Dreams", hexColors: ["#FFB6C1", "#FFDAB9", "#E6E6FA"], isFavorite: false),
        ColorPalette(id: "5", name: "Bloody Red", hexColors: ["#7F0000", "#990000", "#FF0000"], isFavorite: true),
        ColorPalette(id: "6", name: "Lemon Yellow", hexColors: ["#FFF44F", "#FFFACD", "#FFFA78"], isFavorite: false),
        // Add more palettes as needed
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрация ячейки для коллекции
        collectionView.register(UINib(nibName: "PaletteCell", bundle: nil), forCellWithReuseIdentifier: "PaletteCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        savePalettes(palettes: palettes) // Сохранение палитр в UserDefaults
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        palettes = retrieveData() // Обновление данных перед отображением представления
    }
    
    // Метод для сохранения палитр в UserDefaults
    func savePalettes(palettes: [ColorPalette]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(palettes) {
            UserDefaults.standard.set(encodedData, forKey: "colorPaletteKey")
        }
    }
    
    // Метод для получения палитр из UserDefaults
    func retrieveData() -> [ColorPalette] {
        var retrievedPalettes: [ColorPalette] = []
        
        if let encodedData = UserDefaults.standard.data(forKey: "colorPaletteKey") {
            let decoder = JSONDecoder()
            if let decodedPalettes = try? decoder.decode([ColorPalette].self, from: encodedData) {
                retrievedPalettes = decodedPalettes
                for palette in decodedPalettes {
                    print("Palette Name: \(palette.name), isFav: \(palette.isFavorite)")
                }
            }
        }
        
        return retrievedPalettes
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Количество элементов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        palettes = retrieveData()
        return palettes.count
    }
    
    // Конфигурация ячейки коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        palettes = retrieveData()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteCell", for: indexPath) as! PaletteCell
        
        cell.configure(with: palettes[indexPath.row])
        return cell
    }
    
    // Размер ячейки коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // Минимальное расстояние между элементами в секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    // Отступы для секции коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Обработка выбора элемента коллекции
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        palettes = retrieveData()
        let selectedPalette = palettes[indexPath.item]
        let detailVC = DetailViewController()
        detailVC.colorPalette = selectedPalette
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

/*
 Комментарии к коду:
 Класс ViewController: Управляет основным экраном, содержащим коллекцию цветовых палитр.

 itemsPerRow: Количество элементов в одном ряду коллекции.
 sectionInsets: Отступы для секции коллекции.
 collectionView: UICollectionView, отображающая цветовые палитры.
 palettes: Массив цветовых палитр.
 viewDidLoad(): Метод, вызываемый после загрузки представления. Регистрирует ячейку, устанавливает делегаты и сохраняет палитры.
 viewWillAppear(_:): Метод, вызываемый перед отображением представления. Обновляет данные палитр.
 savePalettes(palettes:): Сохраняет палитры в UserDefaults.
 retrieveData() -> [ColorPalette]: Получает палитры из UserDefaults.
 Расширение ViewController:

 UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout: Протоколы для управления данными и поведением коллекции.
 collectionView(_:numberOfItemsInSection:): Возвращает количество элементов в секции.
 collectionView(_:cellForItemAt:): Настраивает ячейку коллекции.
 collectionView(_:layout:sizeForItemAt:): Определяет размер ячейки коллекции.
 collectionView(_:layout:minimumInteritemSpacingForSectionAt:): Задает минимальное расстояние между элементами.
 collectionView(_:layout:insetForSectionAt:): Устанавливает отступы для секции.
 collectionView(_:didSelectItemAt:): Обрабатывает выбор элемента коллекции и переходит на детальный экран.
 */
