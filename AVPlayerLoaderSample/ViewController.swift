//
//  ViewController.swift
//  AVPlayerLoaderSample
//
//  Created by HANYU, Koji on 2018/12/11.
//  Copyright © 2018年 HANYU,  koji. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var goNextButton: UIButton!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goNextButton.isEnabled = false
        
        self.loadItem()
    }
    
    func loadItem() {
        self.statusLabel.text = "LOADING…"
        
        let url = URL(string: "https://example.com/path/to/resource")!
        let loader = AVPlayerLoader(url)
        loader.load() { result in
            switch result {
            case .success(let player):
                self.player = player
                self.statusLabel.text = "SUCCESS"
                self.goNextButton.isEnabled = true
                
            case .failed:
                self.statusLabel.text = "FAILED"
                
            case .timedOut:
                self.statusLabel.text = "TIMED OUT"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlayerViewController {
            controller.player = self.player
        }
    }
}

