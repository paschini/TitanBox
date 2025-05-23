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
    
    let recognizedDataTypes:Set<DataScannerViewController.RecognizedDataType> = [
        .text(languages: ["sv", "en"]),
        .barcode(symbologies: [.qr])
        // uncomment to filter on specific languages (e.g., Swedish, english)
//        .text(languages: ["sv"]),
//        .text(languages: ["en"]),
        // uncomment to filter on specific content types (e.g., URLs)
        // .text(textContentType: .URL)
    ]
    
    func makeUIViewController(context: Context) -> DataScannerViewController
    {
        return DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }

    func makeCoordinator() -> Coordinator
    {
        Coordinator(recognizedItems: $recognizedItems)
    }

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate
    {
        @Binding var recognizedItems: [RecognizedItem]

        init(recognizedItems: Binding<[RecognizedItem]>) {
            self._recognizedItems = recognizedItems
        }
                
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                print("tapped on text: \(text.transcript)")
            case .barcode(let barcode):
                print("tapped on barcode: \(barcode.payloadStringValue ?? "unknown")")
            default:
                print("unexpected item")
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            recognizedItems.append(contentsOf: addedItems)
            print("added")
            print(addedItems)
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
