//
//  TitanBoxApp.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-11.
//

import SwiftUI

@main
struct TitanBoxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            BoxDataView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            InitialView()
        }
    }
}
