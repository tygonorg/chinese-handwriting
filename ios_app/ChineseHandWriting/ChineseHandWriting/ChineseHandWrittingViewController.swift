//
//  ChineseHandWrittingViewController.swift
//  ChineseHandWriting
//
//  Created by Hung Tran on 05/05/2021.
//

import UIKit
enum PenType {
    case pen,eraser
}

class ChineseHandWrittingViewController: UIViewController {
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 15.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var type : PenType = .pen
    
    @IBOutlet weak var eraser_bottom: NSLayoutConstraint!
    @IBOutlet weak var pen_bottom: NSLayoutConstraint!
    @IBOutlet weak var tempImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    func setUpUI() {
        switch type {
        case .pen:
            pen_bottom.constant = 40.0
            eraser_bottom.constant = 20
            brushWidth = 10.0
            color = .black
            self.img_display.image = UIImage(named: "pen")
        case .eraser:
            pen_bottom.constant = 20.0
            eraser_bottom.constant = 40.0
            color = .white
            brushWidth = 15.0
            self.img_display.image = UIImage(named: "eraser")
        }
    }
    
    @IBAction func eraser_select(_ sender: Any) {
        type = .eraser
        self.setUpUI()
    }
    @IBOutlet weak var img_display: UIImageView!
    @IBAction func pen_select(_ sender: Any) {
        type = .pen
        self.setUpUI()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: tempImageView)
    }
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: tempImageView.bounds)
        
        // 2
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        // 3
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        // 4
        context.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        // 6
        swiped = true
        let currentPoint = touch.location(in: tempImageView)
        drawLine(from: lastPoint, to: currentPoint)
        
        // 7
        lastPoint = currentPoint
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if !swiped {
        // draw a single point
        drawLine(from: lastPoint, to: lastPoint)
      }
        
      // Merge tempImageView into mainImageView
//      UIGraphicsBeginImageContext(mainImageView.frame.size)
//      mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
//      tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
//      mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//
//      tempImageView.image = nil
    }

    
    
}
