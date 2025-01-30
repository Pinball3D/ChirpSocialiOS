//
//  NavigationHeader.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 1/7/25.
//
import SwiftUI
struct NavigationHeader: View {
    var headerText: String = ""
    var backText: String = "Chirp"
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text(backText).font(.Jost)
                        }
                    }.foregroundStyle(.primary)
                        .padding()
                    Spacer()
                }
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(maxWidth: .infinity, maxHeight: 2)
            }
            HStack(alignment: .center) {
                Text(headerText).font(.Jost)
            }
        }
    }
}

#Preview {
    VStack {
        NavigationHeader()
        Spacer()
    }
}
