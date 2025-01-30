//
//  ComposeView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/15/24.
//

import SwiftUI
import Drops
import Kingfisher
import PhotosUI
import Foundation
import Alamofire
//#if canImport(ImagePlayground)
//import ImagePlayground
//#endif

struct ComposeView: View {
    @State var imgGen = false
    @State var dividerSize: CGSize = .zero
    var chirpToReply: Chirp? = nil
    var chirpAPI = ChirpAPI()
    @State var postPhotos: [URL] = []
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationController: NavigationController
    @Environment(\.colorScheme) var colorScheme
    @State var caption = ""
    @Environment(\.presentationMode) var presentationMode
    @State var addMenuExpand = false
    var charCounter: CGFloat {
        return CGFloat(caption.count)/500.0
    }
    var body: some View {
        if true {
            VStack {
                HStack {
                    Button {
                        if chirpToReply == nil {
                            navigationController.composeView = false
                        } else {
                            navigationController.replyComposeView = false
                            navigationController.currentChirp = nil
                        }
                    } label: {
                        Text("Cancel")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color("red"))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                    //PhotosPicker(selection: $pickerPhoto, maxSelectionCount: 1, matching: .images) {
                    //    Image(systemName: "photo")
                    //        .font(.system(size: 24))
                    //        .padding()
                    //}
                    //.onChange(of: pickerPhoto) { photo in
                    //   Task {
                    //       for photo in pickerPhoto {
                    //           if let imageData = try await photo.loadTransferable(type: Data.self),
                    //              let image = UIImage(data: imageData) {
                    //               if let url = await convertImage(image: image) {
                    //                  print(Utility().getUser()!.username)
                    //                   uploadFile(fileURL: url, username: "", to: "https://chirpimg.smileyzone.net/upload.php") { //filename in
                    //                       postPhotos.append(URL(string: "https://chirpimg.smileyzone.net/uploads/"+filename)!)
                    //                       print("https://chirpimg.smileyzone.net/uploads/"+filename)
                    //                   }
                    //               }
                    //
                    //            }
                    //        }
                    //        pickerPhoto = []
                    //    }
                    //}
                    Menu("", systemImage: "photo.badge.plus") {
                        PhotoPickerView(postPhotos: $postPhotos)
                        Button("Take a photo", systemImage: "camera") {
                            
                        }
                        if #available(iOS 18.2, *) {
                            Button("Image Playground", systemImage: "wand.and.stars.inverse") {
                                imgGen = true
                            }
                        }
                    }
                    //if #available(iOS 18.2, *) {
                    //    Spacer().frame(width: 0, height: 0).imagePlaygroundSheet(isPresented: //$imgGen) { url in
                    ///        imgGen.toggle()
                     //       Utility.shared.fetchToken { token, error in
                     //           if let gitToken = token {
                     //               do {
                     //                   if let image = UIImage(data: try Data(contentsOf: url)) {
                     //                       Utility.shared.uploadImage(token: gitToken, image: //image) { url, error in
                     //                           if let responseURL = url {
                     //                               postPhotos.append(responseURL)
                     //                           }
                      //                      }
                      //                  }
                       //             } catch {
                      //                  Drops.show("Couldn't upload image")
                       //             }
                      //
                      //          } else {
                     //               Drops.show("Couldn't upload image")
                     //           }
                    //        }
                    //    }
                    //}
                    Spacer()
                    Button {
                        for image in postPhotos {
                            caption = caption + " " + image.absoluteString
                        }
                        if chirpToReply == nil {
                            chirpAPI.chirp(content: caption)
                            navigationController.composeView.toggle()
                        } else {
                            navigationController.replyComposeView = false
                            chirpAPI.chirp(content: caption, parent: chirpToReply!.id)
                            navigationController.currentChirp = nil
                        }
                    } label: {
                        Text(chirpToReply == nil ? "Chirp" : "Reply")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(themeManager.currentTheme.color))
                            .foregroundColor(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.font(themeManager.currentTheme.UIFont.value)
                .padding()
                if (chirpToReply != nil) {
                    VStack {
                        HStack(alignment: .center) {
                            KFImage(URL(string: chirpToReply!.profilePic))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40) //REPLY PROFILE PIC
                            HStack {
                                Text(chirpToReply!.name).bold() //REPLY PROFILE NAME
                                Text("@"+chirpToReply!.username)
                                    .font(.subheadline)
                                //.foregroundColor(Color(.placeholderText))
                                Spacer()
                            }
                            
                        }
                        HStack {
                            VStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 5, height: (dividerSize.height > 0 ? dividerSize.height : 150) - 130)
                            }.frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                GeometryReader { geometry in
                                    ChirpContentView(chirp: chirpToReply!)
                                        .onAppear {
                                            dividerSize = geometry.size
                                        }//REPLY CONTENT
                                }.frame(maxHeight: .infinity)
                                Text("Replying to ")//.foregroundColor(Color(.placeholderText))
                                + Text("@\(chirpToReply!.username)")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        HStack {
                            VStack {
                                KFImage(URL(string: Utility().getUser()!.profilePic))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 40, height: 40)
                                Spacer()
                            }
                            TextArea("Post your reply", text: $caption)
                        }
                        Spacer()
                    }.padding()
                } else {
                    HStack(alignment: .top) {
                        if let user = Utility.shared.getUser() {
                            KFImage(URL(string: user.profilePic))
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                        }
                        
                        TextArea("What's happening?", text: $caption)
                    }.padding()
                }
                ForEach(postPhotos, id: \.self) { photo in
                    KFImage(photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
                Spacer()
                Divider()
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(
                                Color.secondary,
                                lineWidth: 7.5
                            )
                        Circle()
                            .trim(from: 0, to: charCounter)
                            .stroke(
                                Color.accentColor,
                                // 1
                                style: StrokeStyle(
                                    lineWidth: 7.5,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                    }.frame(width: 25, height: 25).padding()
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        } else {
            // Fallback on earlier versions
        }
    }
    
    //func convertImage(image: UIImage) async -> URL? {
    //    guard let jpegData = image.jpegData(compressionQuality: 0.1) else {
    //        print("Failed to convert the image to JPEG.")
    //        return nil
    //    }
    //    let tempDirectory = FileManager.default.temporaryDirectory
    //    let jpegFileName = UUID().uuidString + ".jpg"
    //let jpegFileURL = tempDirectory.appendingPathComponent(jpegFileName)
    //    do {
    //        try jpegData.write(to: jpegFileURL)
    //        print("JPEG image successfully saved at: \(jpegFileURL)")
    //        return jpegFileURL
    //    } catch {
    //        print("Failed to save the JPEG image: \(error)")
    //        return nil
    //    }
    //}
    func uploadFile(fileURL: URL, username: String, to urlString: String, callback: @escaping (_ filename: String) -> Void) {
        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(username)\r\n".data(using: .utf8)!)
        let fileName = fileURL.lastPathComponent
        let mimeType = "application/octet-stream"
        let fileData = try? Data(contentsOf: fileURL)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("Response data: \(responseString ?? "")")
                if let jsonData = responseString!.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    do {
                        let decodedDictionary = try decoder.decode([String: String].self, from: jsonData)
                        print(decodedDictionary)
                        if decodedDictionary.keys.contains("success") {
                            callback(decodedDictionary["file"] ?? "")
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Error converting string to Data")
                }
            }
        }
        
        task.resume()
    }
}

struct TextArea: View {
    @FocusState var focused: Bool
    @Binding var text: String
    let placeholder: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
            //TextViewWrapper(text: $text)
            TextEditor(text: $text)
                .padding(4)
                .disableAutocorrection(true)
                .focused($focused)
                .background(Color.clear)
                //.scrollContentBackground(.hidden)
        }
        .font(.body)
        .onAppear {
            focused = true
        }
        .onChange(of: focused) { newValue in
            if !newValue {
                // Re-focus the text field if it loses focus
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focused = true
                }
            }
        }
    }
    
}


struct TwitterToolbarView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Divider()
        HStack {
            Button(action: {
                // Action for adding an image
            }) {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .padding(.top, 10)
            }
        }.background(colorScheme == .dark ? Color.black : Color.white)
    }
}

#Preview {
    ComposeView()
}


@available(iOS 16.0, *)
struct PhotoPickerView: View {
    @Binding var postPhotos: [URL]
    @State var pickerPhoto: [PhotosPickerItem] = []
    var body: some View {
        PhotosPicker(selection: $pickerPhoto, maxSelectionCount: 1, matching: .images) {
            Label("Pick a photo", systemImage: "photo")
        }
        .onChange(of: pickerPhoto) { _ in
            Task {
                for photo in pickerPhoto {
                    if let imageData = try await photo.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData) {
                        Utility.shared.fetchToken { token, error in
                            if let gitToken = token {
                                Utility.shared.uploadImage(token: gitToken, image: image) { url, error in
                                    if let responseURL = url {
                                        postPhotos.append(responseURL)
                                    }
                                }
                            } else {
                                Drops.show("Couldn't upload image")
                            }
                        }
                    }
                }
            }
        }
    }
}
