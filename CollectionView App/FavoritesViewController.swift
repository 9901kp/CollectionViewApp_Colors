//
//  FavoritesViewController.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 25.01.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var favoriteColors: [ColorPalette] = [] // Массив для хранения избранных цветовых палитр
    
    @IBOutlet weak var tableView: UITableView! // Подключение таблицы из интерфейса
    override func viewDidLoad() {
        super.viewDidLoad()
        // Дополнительная настройка после загрузки представления, если это необходимо
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteColors = filterData() // Обновление данных перед появлением экрана
        
        tableView.register(UINib(nibName: "FavoriteColorTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteColorTableViewCell") // Регистрация ячейки таблицы
        tableView.dataSource = self // Установка источника данных для таблицы
        tableView.reloadData() // Перезагрузка данных таблицы
    }
    
    // Метод для получения данных из UserDefaults
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
    
    // Метод для фильтрации данных, возвращает только избранные палитры
    func filterData() -> [ColorPalette] {
        let colors: [ColorPalette] = retrieveData() // Получаем все палитры
        var favColors: [ColorPalette] = []
        
        for color in colors {
            if color.isFavorite {
                favColors.append(color) // Добавляем только те палитры, которые являются избранными
            }
        }
        
        return favColors
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    // Метод для определения количества строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteColors.count
    }
    
    // Метод для настройки ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteColorTableViewCell", for: indexPath) as! FavoriteColorTableViewCell
        cell.setupFavColor(color: favoriteColors[indexPath.row]) // Настройка ячейки с данными палитры
        return cell
    }
}
/*
 Комментарии к коду:
 Класс FavoritesViewController: Управляет экраном, отображающим избранные цветовые палитры.
 favoriteColors: Массив для хранения избранных палитр.
 tableView: Таблица для отображения палитр.
 viewDidLoad(): Метод, вызываемый после загрузки представления.
 viewWillAppear(_:): Метод, вызываемый перед отображением представления. Обновляет данные и перезагружает таблицу.
 retrieveData() -> [ColorPalette]: Получает данные палитр из UserDefaults.
 filterData() -> [ColorPalette]: Фильтрует данные, оставляя только избранные палитры.
 Расширение FavoritesViewController:
 UITableViewDataSource: Протокол, обеспечивающий предоставление данных для таблицы.
 tableView(_:numberOfRowsInSection:): Определяет количество строк в таблице.
 tableView(_:cellForRowAt:): Настраивает ячейку таблицы для отображения данных.
 */
