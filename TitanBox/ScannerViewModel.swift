//
//  ScannerViewModel.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-13.
import Foundation

class ScannerViewModel: ObservableObject {
    @Published var isShowingScanner: Bool = false
    
//    mutating func setIsShowingScanner(newValue: Bool) {
//        isShowingScanner = newValue
//    }
    
//    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "Qr-code goes here"
}
