//
//  SwiftUIView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-11.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        VStack {
            Text("TitanBox").font(.largeTitle)
            BoxImage()
            Spacer()
            ScanButton()
        }
    }
}

struct BoxImage: View {
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "shippingbox.fill")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(
                    width: geometry.size.width * DrawingConstants.scaleFactor,
                    height: geometry.size.height * DrawingConstants.scaleFactor
                )
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
    
    private struct DrawingConstants {
        static let scaleFactor: CGFloat = 0.6
    }
}

struct ScanButton: View {
    var body: some View {
        Button {
            print("i got tapped")
        } label: {
            HStack {
                Image(systemName: "camera.viewfinder")
                Text("sccan box code")
            }.font(.headline)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView().preferredColorScheme(.dark)
        
        InitialView().preferredColorScheme(.light)
    }
}


