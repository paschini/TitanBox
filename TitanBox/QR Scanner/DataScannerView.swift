//
//  DataScannerView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-12-08.
//

import SwiftUI
import VisionKit

struct DataScannerView : UIViewControllerRepresentable
{
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var showScanner: Bool
    
    let recognizedDataTypes:Set<DataScannerViewController.RecognizedDataType> = [
        .barcode(symbologies: [.qr]),
        // uncomment to filter on specific languages (e.g., Japanese)
        // .text(languages: ["ja"])
        // uncomment to filter on specific content types (e.g., URLs)
        // .text(textContentType: .URL)
    ]
    
    func makeUIViewController(context: Context) -> DataScannerViewController
    {
        return DataScannerViewController(recognizedDataTypes: recognizedDataTypes, qualityLevel: .balanced, recognizesMultipleItems: false, isGuidanceEnabled: true, isHighlightingEnabled: true)
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }

    func makeCoordinator() -> Coordinator
    {
        Coordinator(recognizedItems: $recognizedItems, showScanner: $showScanner)
    }

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate
    {
        @Binding var recognizedItems: [RecognizedItem]
        @Binding var showScanner: Bool

        init(recognizedItems: Binding<[RecognizedItem]>, showScanner: Binding<Bool>) {
            self._recognizedItems = recognizedItems
            self._showScanner = showScanner
        }
                
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                print("text: \(text.transcript)")
            case .barcode(let barcode):
                print("barcode: \(barcode.payloadStringValue ?? "unknown")")
            default:
                print("unexpected item")
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            recognizedItems.append(contentsOf: addedItems)
            print("added")
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter{ item in
                !removedItems.contains(where: {$0.id == item.id})
            }
            print("deleted")
        }

        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("unavailable")
        }
    }
}
