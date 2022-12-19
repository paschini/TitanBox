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
    @State var boxName: String = ""
    
    func addBox(id: UUID) {
        withAnimation {
            let newBox = Box(context: viewContext)
            newBox.id = id
            newBox.timestamp = Date()
            newBox.name = boxName
            
            do {
                print("rying to save new box...")
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Creating new box...")
                .font(.headline)
            VStack {
                TextField("Name", text: $boxName)
            }
            Button {
                print(boxID)
                addBox(id: boxID)
            } label: {
                Text("Add box")
            }
        }
    }
}

struct CreateBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBoxView(boxID: UUID(), boxName: "Test box")
    }
}
