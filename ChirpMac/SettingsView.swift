import SwiftUI

extension Color {
    static let customPink = Color(red: 213 / 255, green: 106 / 255, blue: 135 / 255)
    static let belgianChocolate = Color(red: 0.56, green: 0.43, blue: 0.35)
}

struct SettingsView: View {
    @State var accentColor: Color = Color("AccentColor")
    var body: some View {
        TabView {
            settings
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            
            about
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
    }
    var settings: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        ColorPicker("", selection: $accentColor)
                            .labelsHidden()
                        Text("Accent Color")
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    HStack {
                        Ellipse()
                            .fill(.mint)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.green)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.blue)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.indigo)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.purple)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(Color.customPink)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(Color.belgianChocolate)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.orange)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Ellipse()
                            .fill(.red)
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                
                            }
                        Spacer()
                    }
                    
                    
                }
            }
            .padding()
            .frame(minWidth: 100, maxWidth: 500, minHeight: 100)

        }
    }
    var about: some View {
        NavigationStack {
            List {
                Text("lol")
                    .tabItem{
                        Label("lol", systemImage: "gear")
                    }
                Text("lol")
                    .tabItem{
                        Label("lol", systemImage: "gear")
                    }
            }

        }
    }
}
