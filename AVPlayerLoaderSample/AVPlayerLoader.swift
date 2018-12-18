//
//  AVPlayerLoader.swift
//  AVPlayerLoaderSample
//
//  Created by HANYU, Koji on 2018/12/11.
//  Copyright © 2018年 HANYU,  koji. All rights reserved.
//

import AVFoundation

/// Asset loader that can handle statuses of its request(Success, Failed, Timed out)
final class AVPlayerLoader {
    enum Result {
        case success(AVPlayer)
        case failed
        case timedOut
    }
    
    var itemUrl: URL {
        return (self.playerItem.asset as! AVURLAsset).url
    }
    
    let timeoutInterval: TimeInterval
    private let playerItem: AVPlayerItem

    private var player: AVPlayer?
    private var observation: NSKeyValueObservation?
    private var timer: Timer?

    private var completion: ((Result) -> Void)?
    
    init(_ url: URL, timeoutInterval: TimeInterval = 5.0) {
        self.playerItem = AVPlayerItem(url: url)
        self.timeoutInterval = timeoutInterval
    }
    
    func load(completion: @escaping (Result) -> Void) {
        self.completion = completion
        
        self.startObservation()
        self.startTimer()

        // Start request by initializing instance of `AVPlayer`.
        print("Start loading asset on \(self.itemUrl.absoluteString)")
        self.player = AVPlayer(playerItem: self.playerItem)
        
    }
}

private extension AVPlayerLoader {
    @objc func didTimeout() {
        print("Timed out")
        self.finishLoading(.timedOut)
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: timeoutInterval,
                                          target: self,
                                          selector: #selector(didTimeout),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    func startObservation() {
        guard self.observation == nil else { return }
        
        // `AVPlayer.status` becomes .readyToPlay even when remote file does not exist.
        // To avoid that issue, `AVPlayerLoader` observes `AVPlayerItem.status`.
        self.observation = playerItem.observe(\.status) { item, change in
            switch item.status {
            case .readyToPlay:
                print("Completed")
                self.finishLoading(.success(self.player!))
                
            case .failed:
                print("Failed")
                self.finishLoading(.failed)
                
            case .unknown:
                // Since .unknown is initial value of `AVPlayerItem.status`,
                // this code is never executed.
                break
            }
        }
    }
    
    func finishLoading(_ result: Result) {
        self.timer?.invalidate()
        self.timer = nil
        self.observation?.invalidate()
        self.observation = nil
        
        self.completion?(result)
    }
}
