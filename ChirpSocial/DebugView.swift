//
//  DebugView.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 10/12/24.
//

import SwiftUI

// A generic view that takes any struct and displays its properties
struct DebugView<T>: View {
    let structToInspect: T

    var body: some View {
        List {
            ForEach(getProperties(of: structToInspect), id: \.key) { property in
                HStack {
                    Text(property.key) // Display the property name
                        .fontWeight(.bold)
                    Spacer()
                    Text(property.value) // Display the property value
                }
            }
        }
    }

    // Function that uses reflection to get properties and their values
    func getProperties(of instance: T) -> [(key: String, value: String)] {
        let mirror = Mirror(reflecting: instance)
        return mirror.children.compactMap { child in
            if let label = child.label {
                // Convert the value to String
                let valueString = "\(child.value)"
                return (key: label, value: valueString)
            }
            return nil
        }
    }
}

