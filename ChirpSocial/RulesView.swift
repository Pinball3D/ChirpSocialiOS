//
//  RulesView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/30/24.
//
import SwiftUI
struct RulesView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Chirp").font(.Jost)
                    }
                }.foregroundStyle(.primary)
                .padding()
                Spacer()
            }
            Rectangle()
                .fill(Color.accentColor)
                .frame(maxWidth: .infinity, maxHeight: 2)
            Text("Chirp Rules (web view)")
            Spacer()
            
        }
    }
}
