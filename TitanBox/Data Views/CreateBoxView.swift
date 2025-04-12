//
//  CreateBoxView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-12-19.
//

import SwiftUI

struct CreateBoxView: View {
    var boxID: UUID
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var boxName: String = ""
    
    var body: some View {
        VStack {
            Text("Creating new box...")
                .font(.headline)
            TextField("Name", text: $boxName)
            Button {
                print(boxID)
                addBox()
            } label: {
                Text("Add box")
            }
        }
    }
    
    private func addBox() {
        withAnimation {
            let newBox = Box(context: viewContext)
            
            newBox.id = boxID
            newBox.timestamp = Date()
            newBox.name = boxName
            
            print("me running")
            
            do {
                print("trying to save new box...")
                if viewContext.hasChanges {
                    try viewContext.save()
                    dismiss()
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CreateBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBoxView(boxID: UUID(), boxName: "Preview box")
    }
}
