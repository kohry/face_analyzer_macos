//
//  ViewController.swift
//  waefawefwef
//
//  Created by gorakgarak mackbook on 2018. 5. 2..
//  Copyright © 2018년 kancinsoft. All rights reserved.
//

import Cocoa

import Vision

class ViewController: NSViewController {

    @IBOutlet weak var desc: NSTextField!
    @IBOutlet weak var path: NSTextField!
    @IBOutlet weak var image: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        path.stringValue = "/Users/kohry/Documents/faceimage.png"

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func readImageFiles(_ sender: Any) {
        
        //open file with file manager
        let fileManager = FileManager.default
        
        //let contents = try! fileManager.contentsOfDirectory(atPath: path.stringValue)
        //contents.map { analyze( $0 as! CGImage ) }
//        analyze( contents as! CGImage )
        
        let str = path.stringValue
        
        if fileManager.fileExists(atPath: str) {
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: str))
            
            let ciimage = CIImage(contentsOf: URL(fileURLWithPath: str))
            
            
//            let ciimage = CIImage(data: Data(contentsOf: URL(fileURLWithPath: path.stringValue)))
            
            
            let context = CIContext(options: nil)
            let cgimage = context.createCGImage(ciimage!, from: ciimage!.extent)
            analyze(cgimage!)
        }
        
        
        
//        if fileManager.fileExists(atPath: path.stringValue) {
//            let url2 = URL.init(string: "sibal")
//            let url = URL(string: path.stringValue)!
//            CIImage(data: Data("sibal"))
//
//
//            analyze(image)
//        }
//
        //for loop for analyzing faces.
        
        
    }
    
    
    func analyze(_ image: CGImage) {
        
        let request = VNDetectFaceRectanglesRequest { (req, error) in
            if let error = error {
                print("Failed to detect faces", error)
                //alert
                return
            }
            guard let observation = req.results as? [VNFaceObservation] else { fatalError("Unexpected Result Type") }
            observation.forEach({ (observation) in DispatchQueue.main.async { print(observation.boundingBox) } })
        }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do { try handler.perform([request]) } catch let reqError { print("Error in req",reqError) }
        }
        
        let faceLandmarks = VNDetectFaceLandmarksRequest()
        let faceLandmarksDetectionRequest = VNSequenceRequestHandler()
        
        try? faceLandmarksDetectionRequest.perform([faceLandmarks], on: image)
        if let landmarksResults = faceLandmarks.results as? [VNFaceObservation] {
            for observation in landmarksResults {
                DispatchQueue.main.async {
                    if let boundingBox = faceLandmarks.inputFaceObservations?.first?.boundingBox {
                        
                        //different types of landmarks
                        let faceContour = observation.landmarks?.faceContour
                        
                        let leftEye = observation.landmarks?.leftEye
                        
                        let rightEye = observation.landmarks?.rightEye
                        
                        let nose = observation.landmarks?.nose
                        
                        let lips = observation.landmarks?.innerLips
                        
                        let leftEyebrow = observation.landmarks?.leftEyebrow
                        
                        let rightEyebrow = observation.landmarks?.rightEyebrow
                        
                        let noseCrest = observation.landmarks?.noseCrest
                        
                        let outerLips = observation.landmarks?.outerLips
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func export(_ sender: Any) {
    }
    
    @IBAction func close(_ sender: Any) {
    }
    
}

