//
//  DetailViewController.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 13.01.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var currentPage = 0
    var colors: [UIColor] = [] {
        didSet {
            // Перезагружаем данные коллекции, когда меняется массив цветов
            collectionView.reloadData()
        }
    }

    var colorPalette: ColorPalette?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Регистрация ячейки коллекции
        collectionView.register(UINib(nibName: "HexColorsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HexColorsCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // Метод для настройки представления
    private func configureView() {
        guard let colorPalette = colorPalette else { return }
        colors = colorPalette.getColors(hexColors: colorPalette.hexColors)
        nameLabel.text = colorPalette.name
        descLabel.text = colorPalette.hexColors.joined(separator: ",")
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Метод для создания и настройки ячейки коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HexColorsCollectionViewCell", for: indexPath) as! HexColorsCollectionViewCell
        cell.setup(color: colors[indexPath.item])
        return cell
    }
    
    // Метод для определения количества элементов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(colors.count)
        return colors.count
    }
    
    // Метод для определения размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // Метод для задания минимального расстояния между линиями ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    // Метод вызывается при остановке прокрутки UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollView contentOffset x:\(scrollView.contentOffset.x)")
        print("scrollView frame width:\(scrollView.contentOffset.x)")
        // Обновляем текущую страницу в UIPageControl
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}

/*
 Комментарии к коду:
 Класс DetailViewController: Представляет контроллер, отображающий детали выбранной палитры цветов.

 collectionView, pageControl, descLabel, nameLabel: Связи с элементами интерфейса.
 currentPage: Текущая страница в UIPageControl.
 colors: Массив цветов, отображаемых в коллекции.
 colorPalette: Выбранная палитра цветов.
 viewDidLoad(): Настраивает начальное состояние контроллера.
 configureView(): Настраивает представление на основе выбранной палитры цветов.
 Расширение DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout: Реализует методы для работы с коллекцией.

 collectionView(_:cellForItemAt:): Создает и настраивает ячейку коллекции.
 collectionView(_:numberOfItemsInSection:): Возвращает количество элементов в секции.
 collectionView(_:layout:sizeForItemAt:): Определяет размер ячейки.
 collectionView(_:layout:minimumLineSpacingForSectionAt:): Определяет минимальное расстояние между линиями ячеек.
 Расширение DetailViewController: UIScrollViewDelegate: Реализует методы делегата UIScrollView.

 scrollViewDidEndDecelerating(_:): Обновляет текущую страницу в UIPageControl при остановке прокрутки.
 */
