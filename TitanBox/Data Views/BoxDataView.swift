//
//  ContentView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-11.
//

import SwiftUI
import CoreData

struct BoxDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Box.timestamp, ascending: true)],
        animation: .default)
    private var boxes: FetchedResults<Box>
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(boxes) { box in
                    NavigationLink { // destination: im declaring it here instead
                        Text("Box created at \(box.timestamp ?? Date(), formatter: boxFormatter)")
                        Text("Box name: \(box.name ?? "Unknown box")")
                        Text("Box id: \(box.id?.uuidString ?? "not found")")
                    } label: {
                        Text(box.name ?? box.id?.uuidString ?? "Unknown box")
                    }
                }
                .onDelete(perform: deleteBoxes)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        deleteBoxes(offsets: IndexSet(0..<boxes.endIndex))
                    } label: {
                        Text("Nuke data")
                    }
                }
                ToolbarItem {
                    Button {
                        print("should go to scanner view")
                    } label: {
                        Label("Add box", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteBoxes(offsets: IndexSet) {
        withAnimation {
            offsets.map { boxes[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let boxFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}() // self calling function

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BoxDataView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.dark)
        BoxDataView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).preferredColorScheme(.light)
    }
}
