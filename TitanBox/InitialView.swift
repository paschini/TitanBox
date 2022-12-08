//
//  SwiftUIView.swift
//  TitanBox
//
//  Created by Paschini, Camila on 2022-03-11.
//

import SwiftUI

struct InitialView: View {
    @State var isShowingScanner: Bool = false
    
    var body: some View {
        isShowingScanner ?
            AnyView(ScannerView()) :
        AnyView(AppPresentationView(showScanner: $isShowingScanner))
    }
}

struct AppPresentationView: View {
    @Binding var showScanner: Bool
    
    var body: some View {
        VStack {
            Text("TitanBox").font(.title)
            BoxImage()
            Button {
                showScanner = true
            } label: {
                HStack {
                    Image(systemName: "camera.viewfinder")
                    Text("scan box code")
                }
            }
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

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView().preferredColorScheme(.dark)
        
        InitialView().preferredColorScheme(.light)
    }
}


