//
//  AppTabBar.swift
//  round-tab-bars
//
//  Created by Faizan Mahmood on 25/07/2023.
//

/*
 So the coordinate system is somewhat different here than the simple match calculation system. For start and end angles, see the
 angels-in-coordinate-system file in the left pane.
 
 */

struct AppTabbarConfig {
    var middleArcEnabled: Bool = false
    var sideArcEnabled: Bool = false
    var barHeightIncreaseValue: CGFloat = 0
}

import UIKit

class AppTabBar: UITabBar {

    private var shapeLayer: CALayer?
    var config: AppTabbarConfig = .init(middleArcEnabled: true, sideArcEnabled: true)
    var barHeightIncreaseValue: CGFloat {
        return config.barHeightIncreaseValue
    }

    private func addShape() {

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        shapeLayer.shadowOffset = CGSize(width: 0, height: -1)
        shapeLayer.shadowRadius = 3
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.16

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
        self.unselectedItemTintColor = UIColor.gray
        self.tintColor = UIColor.blue
    }

    func createPath() -> CGPath {
        var path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: -barHeightIncreaseValue))
        if config.sideArcEnabled {
            addLeftArc(&path)
        }
        if config.middleArcEnabled {
            path.addLine(to: CGPoint.init(x: self.frame.size.width/2 - 40, y: -barHeightIncreaseValue))
            addMiddleArc(&path)
        }

        if config.sideArcEnabled {
            path.addLine(to: CGPoint(x: self.frame.width - 35, y: -barHeightIncreaseValue))
            addRightArc(path: &path)
        } else {
            path.addLine(to: CGPoint(x: self.frame.width, y: -barHeightIncreaseValue))
        }
        
        // close the path
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath

    }
    
    fileprivate func addLeftArc(_ path: inout UIBezierPath) {
        let endAngel: CGFloat = (3/2) * .pi
        path.addArc(withCenter: CGPoint(x: 35, y: 35 - barHeightIncreaseValue),
                    radius: 35,
                    startAngle: .pi,
                    endAngle: endAngel,
                    clockwise: true)
    }
    
    fileprivate func addMiddleArc(_ path: inout UIBezierPath) {
        let endAngel: CGFloat = .pi / 180
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2, y: 0 - barHeightIncreaseValue),
                    radius: 40,
                    startAngle: .pi,
                    endAngle: endAngel,
                    clockwise: true)
    }
    
    fileprivate func addRightArc(path: inout UIBezierPath) {
        path.addArc(withCenter: CGPoint(x: self.frame.width - 35, y: 35 - barHeightIncreaseValue),
                    radius: 35,
                    startAngle: (3/2) * .pi,//.pi,
                    endAngle: .pi/180,
                    clockwise: true)
    }
}
