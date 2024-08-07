import UIKit

extension Main2ModuleViewController {
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }

        view.transform = view.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )

        gesture.scale = 1
    }

    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }

        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0.0
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }

        let translation = gesture.translation(in: view.superview)

        view.center = CGPoint(
            x: view.center.x + translation.x,
            y: view.center.y + translation.y
        )

        gesture.setTranslation(.zero, in: view.superview)
    }
}
