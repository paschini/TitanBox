//
//  SwiftUIView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-11.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var vm: ScannerViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Box.name, ascending: true)],
        animation: .default)
    private var boxes: FetchedResults<Box>
//    let persistenceController = PersistenceController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("TitanBox").font(.title)
                BoxImage()
                
//                if(!boxes.isEmpty) {
//                    NavigationLink(destination: BoxDataView().environment(\.managedObjectContext, persistenceController.container.viewContext)) {
//                        Text("See all boxes")
//                    }
//                }
                
                NavigationLink(destination: BoxDataView()) {
                    Text("See all boxes")
                }
                
                NavigationLink(destination: ScannerView(vm: _vm)) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                        Text("scan box code")
                    }
                }
            }
        }
    }
    
//    private func deleteBoxes(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { boxes[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct BoxImage: View {
    @EnvironmentObject var vm: ScannerViewModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(systemName: "shippingbox.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(
                        width: geometry.size.width * DrawingConstants.scaleFactor,
                        height: geometry.size.height * DrawingConstants.scaleFactor
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height/2, alignment: .top)
            }
            
            if (!vm.recognizedItems.isEmpty) {
                ResultView(recognizedItems: $vm.recognizedItems)
            }
        }
    }
    
    private struct DrawingConstants {
        static let scaleFactor: CGFloat = 0.65
    }
}

struct InitialView_Previews: PreviewProvider {
    static let vm = ScannerViewModel()
        
    static var previews: some View {
        InitialView().environmentObject(vm).preferredColorScheme(.dark)
        InitialView().environmentObject(vm).preferredColorScheme(.light)
    }
}
