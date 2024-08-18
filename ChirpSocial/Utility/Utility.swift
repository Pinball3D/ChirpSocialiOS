//
//  Utility.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 8/16/24.
//
import SwiftUI

class Utility {
    func errorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
}
