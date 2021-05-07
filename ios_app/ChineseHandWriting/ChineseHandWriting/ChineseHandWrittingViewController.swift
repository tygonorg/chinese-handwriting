//
//  ChineseHandWrittingViewController.swift
//  ChineseHandWriting
//
//  Created by Hung Tran on 05/05/2021.
//

import UIKit
import CoreML
import Vision
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
    
    @IBOutlet weak var btn0: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let config = MLModelConfiguration()
            let model = try VNCoreMLModel(for: Mchinese(configuration:config ).model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        // classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [self] in
            guard let results = request.results else {
                //  self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                //  self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(5)
                self.hideSugess()
                for (index, value) in topClassifications.enumerated() {
                    print("\(index): \(value)")
                    if(index == 0){
                        btn0.setTitle(value.identifier, for: .normal)
                        btn0.isHidden = false
                    }
                    if(index == 1){
                        btn1.setTitle(value.identifier, for: .normal)
                        btn1.isHidden = false
                    }
                    if(index == 2){
                        btn2.setTitle(value.identifier, for: .normal)
                        btn2.isHidden = false
                    }
                    if(index == 3){
                        btn3.setTitle(value.identifier, for: .normal)
                        btn3.isHidden = false
                    }
                    if(index == 4){
                        btn4.setTitle(value.identifier, for: .normal)
                        btn4.isHidden = false
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var eraser_bottom: NSLayoutConstraint!
    @IBOutlet weak var pen_bottom: NSLayoutConstraint!
    @IBOutlet weak var drawCanvasView: UIImageView!
    fileprivate func hideSugess() {
        btn0.isHidden = true
        btn1.isHidden = true
        btn2.isHidden = true
        btn3.isHidden = true
        btn4.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        hideSugess()
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
       

        let p =  touch.location(in: drawCanvasView)
        let q =  touch.location(in: self.view)
        if drawCanvasView.frame.contains(q){
            swiped = false
            lastPoint = p
        } else {
            
            print("tap out side image")
            return
        }
    }
    
    
    
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(drawCanvasView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        drawCanvasView.image?.draw(in: drawCanvasView.bounds)
        
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
        drawCanvasView.image = UIGraphicsGetImageFromCurrentImageContext()
        drawCanvasView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let currentPoint = touch.location(in: drawCanvasView)
        let q =  touch.location(in: self.view)
        
        if !drawCanvasView.frame.contains(q) {
            print("move out side")
            return
        }
        swiped = true
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    func takeSnapshotOfView(view:UIView) -> UIImage? {
           UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height))
           view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }

    
    @IBAction func saveimg(_ sender: Any) {
//        let snapshot = self.drawCanvasView.snapshotView(afterScreenUpdates: false)
//
//        UIGraphicsBeginImageContext(snapshot!.bounds.size);
//        snapshot!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot =  self.takeSnapshotOfView(view: self.drawCanvasView)
//        UIGraphicsEndImageContext();
        
       

        
        
//        UIGraphicsBeginImageContext(drawCanvasView.frame.size)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenShot!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
        else {
            self.showAlert("Image saved", message: "The iamge is saved into your Photo Library.")
        }
    }
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        guard let touch = touches.first else {
            return
        }
        let q =  touch.location(in: self.view)
      //  let currentPoint = touch.location(in: tempImageView)
        if !drawCanvasView.frame.contains(q) {
            // if(tempImageView.bounds.contains(p)){
            print("tap end out side!")
            return
           // lastPoint = touch.location(in: tempImageView)
        }
        let screenShot =  self.takeSnapshotOfView(view: self.drawCanvasView)
        // Merge tempImageView into mainImageView
//        UIGraphicsBeginImageContext(drawCanvasView.frame.size)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        updateClassifications(for: screenShot!)
        //
        //      tempImageView.image = nil
    }
    
    
    
}
