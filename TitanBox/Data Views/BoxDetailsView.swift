//
//  BoxDetails.swift
//  TitanBox
//
//  Created by Camila Paschini on 2025-04-12.
//

import SwiftUI

struct BoxDetailsView: View {
    var box: Box
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Box Name: ").bold()
                Text("\(box.name ?? "Unknown box")")
            }
            
            HStack {
                Text("Box created at: ").bold()
                Text("\(box.timestamp ?? Date(), formatter: boxFormatter)")
            }
            
            HStack {
                Text("Box Id: ").bold()
                Text("\(box.id?.uuidString ?? "not found")").font(.footnote)
            }
        }
    }
}

private let boxFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}() // self calling function

//#Preview {
//    BoxDetailsView()
//}
