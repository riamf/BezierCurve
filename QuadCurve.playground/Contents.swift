//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

extension CGPoint {
    func rect(with radius: CGFloat) -> CGRect {
        return CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
    }
}

class ControlView: UIView {
    
    private let quadCurve = CAShapeLayer()
    private let kMargin: CGFloat = 32
    private let kControlPointRadius: CGFloat = 18
    private let controlPointView: UIView = UIView()
    
    private var controlPoint: CGPoint = .zero {
        didSet {
            let bezier = UIBezierPath()
            bezier.move(to: CGPoint(x: frame.minX + kMargin, y: frame.midY))
            bezier.addQuadCurve(to: CGPoint(x: frame.maxX - kMargin,
                                            y: frame.midY),
                                controlPoint: controlPoint)
            quadCurve.path = bezier.cgPath
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addQuadCurve()
        addControlPointControl()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addQuadCurve() {
        controlPoint = CGPoint(x: frame.midX, y:frame.midY)
        quadCurve.lineJoin = kCALineJoinRound
        quadCurve.lineWidth = 3.0
        quadCurve.strokeColor = UIColor.black.cgColor
        quadCurve.fillColor = UIColor.clear.cgColor
        layer.addSublayer(quadCurve)
    }

    private func addControlPointControl() {

        controlPointView.backgroundColor = .red
        controlPointView.frame = controlPoint.rect(with: kControlPointRadius)
        addSubview(controlPointView)
    }

    private func addGesture() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self
            , action: #selector(ControlView.gesture(recognizer:))))
    }

    @objc private func gesture(recognizer: UIGestureRecognizer) {
        
        let point = recognizer.location(in: self)

        switch recognizer.state {
        case .began, .changed, .ended:
            if controlPointView.frame.contains(point) {
                change(controlPoint: point)
            }
        case .cancelled, .failed, .possible:
            print(recognizer.state)
            break
        }
    }

    private func change(controlPoint to: CGPoint) {
        controlPointView.center = to
        controlPoint = to
    }
}


let view = ControlView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view
