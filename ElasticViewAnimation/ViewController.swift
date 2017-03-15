//
//  ViewController.swift
//  ElasticViewAnimation
//
//  Created by Muhammad Azam Bin Baderi on 3/14/17.
//  Copyright © 2017 Muhammad Azam Bin Baderi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: -
    // MARK: Vars
    private let minimalHeight: CGFloat = 50.0
    private let maxWaveHeight: CGFloat = 100.0
    private let shapeLayer = CAShapeLayer()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let l3ControlPointView = UIView()
    private let l2ControlPointView = UIView()
    private let l1ControlPointView = UIView()
    private let cControlPointView = UIView()
    private let r1ControlPointView = UIView()
    private let r2ControlPointView = UIView()
    private let r3ControlPointView = UIView()
    
    // MARK: -
    override func loadView() {
        super.loadView()
        
        l3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        l1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        cControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r1ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r2ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        r3ControlPointView.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
        
        l3ControlPointView.backgroundColor = .red
        l2ControlPointView.backgroundColor = .red
        l1ControlPointView.backgroundColor = .red
        cControlPointView.backgroundColor = .red
        r1ControlPointView.backgroundColor = .red
        r2ControlPointView.backgroundColor = .red
        r3ControlPointView.backgroundColor = .red
        
        view.addSubview(l3ControlPointView)
        view.addSubview(l2ControlPointView)
        view.addSubview(l1ControlPointView)
        view.addSubview(cControlPointView)
        view.addSubview(r1ControlPointView)
        view.addSubview(r2ControlPointView)
        view.addSubview(r3ControlPointView)
        
        shapeLayer.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: minimalHeight)
        shapeLayer.fillColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0).cgColor
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureDidMove(gesture:))))
        
        layoutControlPoints(baseHeight: minimalHeight, waveHeight: 0.0, locationX: view.bounds.width / 2.0)
        updateShapeLayer()
    }
    
    // MARK: -
    // MARK: Methods
    
    @objc fileprivate func panGestureDidMove(gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
        } else {
            let additionalHeight = max(gesture.translation(in: view).y, 0)
            let waveHeight = min(additionalHeight * 0.6, maxWaveHeight)
            let baseHeight = minimalHeight + additionalHeight - waveHeight
            let locationX = gesture.location(in: gesture.view).x
            
            layoutControlPoints(baseHeight: baseHeight, waveHeight: waveHeight, locationX: locationX)
            updateShapeLayer()
        }
    }
    
    fileprivate func layoutControlPoints(baseHeight: CGFloat, waveHeight: CGFloat, locationX: CGFloat) {
        let width = view.bounds.width
        let minLeftX = min((locationX - width / 2.0) * 0.28, 0.0)
        let maxRightX = max(width + (locationX - width / 2.0) * 0.28, width)
        
        let leftPartWidth = locationX - minLeftX
        let rightPartWidth = maxRightX - locationX
        
        l3ControlPointView.center = CGPoint(x: minLeftX, y: baseHeight)
        l2ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.44, y: baseHeight)
        l1ControlPointView.center = CGPoint(x: minLeftX + leftPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        cControlPointView.center = CGPoint(x: locationX , y: baseHeight + waveHeight * 1.36)
        r1ControlPointView.center = CGPoint(x: maxRightX - rightPartWidth * 0.71, y: baseHeight + waveHeight * 0.64)
        r2ControlPointView.center = CGPoint(x: maxRightX - (rightPartWidth * 0.44), y: baseHeight)
        r3ControlPointView.center = CGPoint(x: maxRightX, y: baseHeight)
    }
    
    func updateShapeLayer() {
        shapeLayer.path = currentPath()
    }
    
    fileprivate func currentPath() -> CGPath {
        let width = view.bounds.width
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: l3ControlPointView.dg_center(usePresentationLayerIfPossible: false).y))
        bezierPath.addCurve(to: l1ControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint1: l3ControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint2: l2ControlPointView.dg_center(usePresentationLayerIfPossible: false))
        bezierPath.addCurve(to: r1ControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint1: cControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint2: r1ControlPointView.dg_center(usePresentationLayerIfPossible: false))
        bezierPath.addCurve(to: r3ControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint1: r1ControlPointView.dg_center(usePresentationLayerIfPossible: false),
                            controlPoint2: r2ControlPointView.dg_center(usePresentationLayerIfPossible: false))
        bezierPath.addLine(to: CGPoint(x: width, y: 0.0))
        
        bezierPath.close()
        
        return bezierPath.cgPath 
    }
}

extension UIView {
    func dg_center(usePresentationLayerIfPossible: Bool) -> CGPoint {
        if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
            return presentationLayer.position
        }
        return center
    } 
}
