//
//  PlayerViewController.swift
//  AVPlayerLoaderSample
//
//  Created by HANYU, Koji on 2018/12/11.
//  Copyright © 2018年 HANYU,  koji. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    var player: AVPlayer?
    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let player = self.player else { return }
        self.playerView.set(player: player)
        player.play()
    }
}

class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override var layer: AVPlayerLayer {
        return super.layer as! AVPlayerLayer
    }
    
    func set(player: AVPlayer) {
        self.layer.player = player
    }
}
