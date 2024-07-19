//
//  ScrollGesture.swift
//
//
//  Created by Алексей Даневич on 12.07.2024.
//

import SwiftUI
import UIKit

public struct ScrollGesture: UIViewRepresentable {
    private let gestureID = UUID().uuidString
    var onChange: (UIPanGestureRecognizer) -> ()

    public init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
        self.onChange = onChange
    }

    public func makeUIView(context: Context) -> some UIView {
        return UIView()
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview,
               !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                superView.addGestureRecognizer(gesture)
            }
        }
    }

    public final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> ()

        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }

        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }

        public func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            return true
        }
    }
}
