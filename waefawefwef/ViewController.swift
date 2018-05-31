
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
    
    let DEFAULT_PATH = "/Users/kohry/Documents/face/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        path.stringValue = DEFAULT_PATH

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
        
        let contents = try! fileManager.contentsOfDirectory(atPath: path.stringValue)
        
        desc.stringValue = ""
        
        contents.forEach { (fileName) in
            
            
            if let ciimage = CIImage(contentsOf: URL(fileURLWithPath: path.stringValue + fileName)) {
                let context = CIContext(options: nil)
                
                let cgimage = context.createCGImage(ciimage, from: ciimage.extent)
                analyze(cgimage!, fileName: fileName)
            }
            
        }
        
        
        
//        if fileManager.fileExists(atPath: path.stringValue) {
//            let url2 = URL.init(string: "sibal")
//            let url = URL(string: path.stringValue)!
//            CIImage(data: Data("sibal"))
//
//
//            analyze(image)
//        }
        
    }
    
    
    func analyze(_ image: CGImage, fileName: String) {
        
        let faceRequest = VNDetectFaceLandmarksRequest{ (req, error) in
            if let results = req.results as? [VNFaceObservation] {
                for observation in results {
                    
                    print(fileName)
                    print(observation.landmarks?.allPoints?.normalizedPoints)
                    
                    
                    let allPointsInString = observation.landmarks?.allPoints?.normalizedPoints

                    
//                    let faceCountour = observation.landmarks?.faceContour?.normalizedPoints
//
//                    let leftEye = observation.landmarks?.leftEye?.normalizedPoints
//
//                    let rightEye = observation.landmarks?.rightEye?.normalizedPoints
//
//                    let nose = observation.landmarks?.nose?.normalizedPoints
//
//                    let innerLips = observation.landmarks?.innerLips?.normalizedPoints
//
//                    let outerLips = observation.landmarks?.outerLips?.normalizedPoints
//
//                    print(observation.landmarks?.allPoints?.normalizedPoints)
//
//                    let leftEyebrow = observation.landmarks?.leftEyebrow?.normalizedPoints
//
//                    let rightEyebrow = observation.landmarks?.rightEyebrow?.normalizedPoints
//
//                    let noseCrest = observation.landmarks?.noseCrest?.normalizedPoints
                    
                    self.desc.stringValue = self.desc.stringValue + fileName + ":" +  String(describing: allPointsInString) + "\n"
                    
                }
            }
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: image, options: [:])

        try? imageRequestHandler.perform([faceRequest])
        
        
    }
    
    @IBAction func export(_ sender: Any) {
        
        try? Data(desc.stringValue.utf8).write(to: URL(fileURLWithPath: path.stringValue + "desc.txt"))
        
    }
    
    @IBAction func close(_ sender: Any) {
    }
    
}

