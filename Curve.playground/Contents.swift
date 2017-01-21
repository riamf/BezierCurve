//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

extension CGPoint {
    func rect(with radius: CGFloat) -> CGRect {
        return CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
    }
}

class ControlView: UIView {
    
    private let curve = CAShapeLayer()
    private let kMargin: CGFloat = 32
    private let kControlPointRadius: CGFloat = 18
    private let firstControlPointView: UIView = UIView()
    private let secondControlPointView: UIView = UIView()
    
    private var controlPoints: (first: CGPoint,second: CGPoint) = (.zero,.zero) {
        didSet {
            firstControlPointView.center = controlPoints.first
            secondControlPointView.center = controlPoints.second
            let bezier = UIBezierPath()
            bezier.move(to: CGPoint(x: frame.minX + kMargin, y: frame.midY))
            bezier.addCurve(to: CGPoint(x: frame.maxX - kMargin,
                                        y: frame.midY)
                , controlPoint1: controlPoints.first, controlPoint2: controlPoints.second)
            curve.path = bezier.cgPath
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCurve()
        addControlPointControl()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCurve() {
        controlPoints = (CGPoint(x: frame.midX, y:frame.midY),
                        CGPoint(x: frame.midX, y:frame.midY))
        curve.lineJoin = kCALineJoinRound
        curve.lineWidth = 3.0
        curve.strokeColor = UIColor.black.cgColor
        curve.fillColor = UIColor.clear.cgColor
        layer.addSublayer(curve)
    }
    
    private func addControlPointControl() {
        
        firstControlPointView.backgroundColor = .red
        firstControlPointView.frame = controlPoints.first.rect(with: kControlPointRadius)
        addSubview(firstControlPointView)
        secondControlPointView.backgroundColor = .blue
        secondControlPointView.frame = controlPoints.second.rect(with: kControlPointRadius)
        addSubview(secondControlPointView)
    }
    
    private func addGesture() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self
            , action: #selector(ControlView.gesture(recognizer:))))
    }
    
    @objc private func gesture(recognizer: UIGestureRecognizer) {
        
        let point = recognizer.location(in: self)
        switch recognizer.state {
        case .began, .changed, .ended:
            if let points = control(at: point) {
                controlPoints = points
            }
            break
        default:
            break
        }
    }

    func control(at touchPoint: CGPoint) -> (CGPoint, CGPoint)? {
        if secondControlPointView.frame.contains(touchPoint) {
            return (firstControlPointView.center, touchPoint)
        }
        if firstControlPointView.frame.contains(touchPoint) {
            return (touchPoint, secondControlPointView.center)
        }
        return nil
    }
}


let view = ControlView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view
