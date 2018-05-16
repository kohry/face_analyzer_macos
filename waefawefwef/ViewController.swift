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
        
        let contents = try fileManager.contentsOfDirectory(atPath: path.stringValue)
        let urls = contents.map { analyze( $0 as? Image ) }
        
        //for loop for analyzing faces.
        
        
    }
    
    
    func analyze(_ image: Any) {
        
        let request = VNDetectFaceRectanglesRequest { (req, error) in
            if let error = error {
                print("Failed to detect faces", error)
                //alert
                return
            }
            
            guard let observation = req.results as? [VNFaceObservation]
                else { fatalError("Unexpected Result Type") }
            
            observation.forEach({ (observation) in
                
                DispatchQueue.main.async {
                    print(observation.boundingBox)
                    
                }
                
            })
            
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch let reqError {
                print("Error in req",reqError)
            }
        }
        
    }
    
    @IBAction func export(_ sender: Any) {
    }
    
    @IBAction func close(_ sender: Any) {
    }
    
}

