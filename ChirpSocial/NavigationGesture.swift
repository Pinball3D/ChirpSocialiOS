//
//  NavigationGesture.swift
//  ChirpSocial
//
//  Created by Andrew Smiley on 11/13/24.
//
import Foundation
import SwiftUI

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.isHidden = true
        super.viewWillLayoutSubviews()
        //navigationBar.isHidden = true
    }
}

struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                NavigationBarHider()
            )
    }
}

struct NavigationBarHider: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = UINavigationController()
        controller.navigationBar.isHidden = true
        return controller
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        uiViewController.navigationBar.isHidden = true
    }
}

extension View {
    func hideNavigationBar() -> some View {
        self.modifier(HideNavigationBarModifier())
    }
}
