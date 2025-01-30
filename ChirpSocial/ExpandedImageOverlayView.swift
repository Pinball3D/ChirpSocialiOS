//
//  ExpandedImageOverlayView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 9/23/24.
//

import SwiftUI
//import Zoomable
import Kingfisher

struct ExpandedImageOverlayView: View {
    @EnvironmentObject var navigationController: NavigationController
    var image: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            KFImage(URL(string: image)).resizable().scaledToFit()//.zoomable().padding()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        navigationController.imageOverlay = nil
                    } label: {
                        Image(systemName: "xmark")
                    }.font(.largeTitle).foregroundStyle(.primary).padding(.horizontal).padding(.horizontal).padding(.horizontal)
                }
                Spacer()
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ExpandedImageOverlayView(image: "https://google.com/favicon.ico")
}
