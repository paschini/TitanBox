//
//  ScannerViewModel.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-13.


import Foundation
import AVKit
import VisionKit
import SwiftUI

enum DataScannerAccessStatusType //helps to determine the entry scenerio of the app
{
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}


@MainActor
final class ScannerViewModel: ObservableObject  //helps to reflect back the changes made to the observed object by reloading the view
{    
    @Published var dataScannerAccessStatusType : DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    
    private var isScannerAvailable : Bool
    {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    func requestDataScannerAccessStatus() async
    {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else
        {
            dataScannerAccessStatusType = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video)
        {
        case .authorized:
            dataScannerAccessStatusType = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
        case .restricted,.denied:
            dataScannerAccessStatusType = .cameraAccessNotGranted
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted
            {
                dataScannerAccessStatusType = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            }
            else
            {
                dataScannerAccessStatusType = .cameraAccessNotGranted
            }
        default : break
        }
    }
}
