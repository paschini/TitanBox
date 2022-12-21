//
//  ScannerView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-13.
//
// Reference: https://github.com/Casey-1412109/Scanner

import VisionKit
import SwiftUI

struct ScannerView: View {
    @EnvironmentObject var vm: ScannerViewModel
    
    var body: some View
    {
        switch vm.dataScannerAccessStatusType
        {
        case .scannerAvailable:
            MainView(recognizedItems: $vm.recognizedItems)
        case .cameraNotAvailable:
            Text("Could not find an available camera")
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning barcode with this app")
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
}

private struct MainView: View {
    @Binding var recognizedItems: [RecognizedItem]
    
    var body: some View {
        DataScannerView(recognizedItems: $recognizedItems)
            .ignoresSafeArea()
            .sheet(isPresented: .constant(!$recognizedItems.isEmpty)) {
                ResultView(recognizedItems: $recognizedItems)
                    .background(.ultraThinMaterial)
                    .presentationDetents([.medium, .fraction(0.25)])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled()
                    .onAppear(){
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else{
                            return
                        }
                        controller.view.backgroundColor = .clear
                    }
            }
    }
}

struct ResultView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var recognizedItems: [RecognizedItem]
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Box.name, ascending: true)],
        animation: .default)
    private var boxes: FetchedResults<Box>

    
    var body: some View {
        NavigationView {
            VStack{
                Text("Scanned boxes:").font(.headline)
                ScrollView{
                    LazyVStack(alignment: .leading, spacing: 16){
                        ForEach(recognizedItems){ item in
                            switch item
                            {
                            case .barcode(let barcode):
                                
                                let newBox = Box(context: viewContext)
                                
                                let foundBox: Box = boxes.first { box in
                                    box.id?.uuidString == barcode.payloadStringValue
                                } ?? newBox
                                
                                
                                HStack {
                                    Text(foundBox.name ?? "Unknown box")
                                    
                                    if (foundBox.name == nil) {
                                        NavigationLink(destination: CreateBoxView(boxID: UUID(uuidString: barcode.payloadStringValue ?? UUID().uuidString) ?? UUID()))
                                        { Text("Create box") }
                                    } else {
                                        Button {
                                            print("go to box detail view")
                                        } label: {
                                            Text("View box")
                                        }
                                    }
                                }
                            case .text(let text): // should never get here, since we only care about QR codes.
                                Text(text.transcript)
                            @unknown default:
                                Text("Unknown")
                            }
                        }
                    }.padding()
                }
            }.padding()
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static let vm = ScannerViewModel()
    
//    static let vm = ({ () -> ScannerViewModel in
//        let envObj = ScannerViewModel()
//        envObj.isShowingScanner = true
//        envObj.recognizedItems = ({ () -> RecognizedItem in
//            let item = RecognizedItem()
//            item.id = UUID()
//        }())
//        envObj.dataScannerAccessStatusType = .scannerAvailable
//        return envObj
//    }() )

    static var previews: some View {
        ScannerView().environmentObject(vm).preferredColorScheme(.dark)
        ScannerView().environmentObject(vm).preferredColorScheme(.light)
    }
}
