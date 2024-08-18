//
//  ComposeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI
import RichTextKit

struct ComposeView: View {
    @Binding var popover: Bool
    @State var content: String = ""
    var chirpAPI = ChirpAPI()
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    popover.toggle()
                }
                Spacer()
                Button("Chirp") {
                    chirpAPI.chirp(content: content)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.black)
            }.padding()
            TextEditor(text: self.$content).font(.headline).overlay {
                if content == "" {
                    VStack {
                        HStack {
                            Text("What's on your mind?").font(.headline).foregroundStyle(Color.gray).padding(.top, 10).padding(.horizontal, 5)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ComposeView(popover: .constant(true))
}
