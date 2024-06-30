//
//  TakePhotoViewController.swift
//  CollectionView App
//
//  Created by Yerkezhan Zheneessova on 25.01.2024.
//

import UIKit
import AVFoundation

class TakePhotoViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession! // Сессия захвата видео
    var imagePhotoOutput: AVCapturePhotoOutput! // Выход для захвата фото
    var cameraDevices: AVCaptureDevice! // Устройство камеры
    
    enum CameraCase {
        case front // Передняя камера
        case back // Задняя камера
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in take photo class")
        // Дополнительная настройка после загрузки представления
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera(cameraCase: .front) // Подготовка камеры перед отображением
    }
    
    // Метод для подготовки камеры
    func prepareCamera(cameraCase: CameraCase) {
        
        // Удаление существующих слоев
        if let sublayers = self.view.layer.sublayers {
            for sublayer in sublayers {
                if sublayer.isKind(of: AVCaptureVideoPreviewLayer.self) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        captureSession = AVCaptureSession() // Создание новой сессии захвата
        // Поиск устройства камеры в зависимости от переданной позиции
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: cameraCase == .front ? .front : .back).devices.first else { return }
        // Создание входа для захвата видео
        let videoInput = try? AVCaptureDeviceInput(device: device)
        if captureSession.canAddInput(videoInput!) {
            captureSession.addInput(videoInput!) // Добавление входа в сессию
            imagePhotoOutput = AVCapturePhotoOutput() // Настройка выхода для захвата фото
            captureSession.addOutput(imagePhotoOutput) // Добавление выхода в сессию
        }
        
        // Создание слоя для предварительного просмотра видео
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        // Добавление слоя предварительного просмотра видео к слою представления
        self.view.layer.addSublayer(previewLayer)
        
        // Запуск сессии захвата в фоновом потоке
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}
/*
 Комментарии к коду:
 Класс TakePhotoViewController: Управляет функциональностью захвата фото с помощью камеры.
 captureSession: Сессия захвата видео.
 imagePhotoOutput: Выход для захвата фото.
 cameraDevices: Устройство камеры.
 CameraCase: Перечисление для выбора передней или задней камеры.
 viewDidLoad(): Метод, вызываемый после загрузки представления, для первоначальной настройки.
 viewWillAppear(_:): Метод, вызываемый перед отображением представления, подготавливает камеру.
 prepareCamera(cameraCase:): Метод для настройки и подготовки камеры в зависимости от выбранной позиции (передняя или задняя камера).
 Удаление существующих слоев: Удаляет все слои предварительного просмотра, если они уже существуют.
 Создание новой сессии захвата: Инициализация новой сессии захвата.
 Поиск и настройка устройства камеры: Находит устройство камеры (передняя или задняя) и добавляет вход для захвата видео в сессию.
 Создание слоя предварительного просмотра: Создает и добавляет слой предварительного просмотра видео к слою представления.
 Запуск сессии захвата: Запускает сессию захвата в фоновом потоке для предотвращения блокировки основного потока.
 */
