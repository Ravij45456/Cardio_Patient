//
//  VideoPlayerViewConntrollerViewController.swift
//  QardiyoHF
//
//  Created by Ravi on 14/05/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit

class VideoPlayerViewConntrollerViewController:UIViewController {
    var fileURL = URL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
    var player : VGPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
     //   let url = URL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
//        if url != nil {
//            player = VGPlayer(URL: fileURL)
//        }
        player = VGPlayer(URL: fileURL!)
    
        
        player?.delegate = self
        view.addSubview((player?.displayView)!)
        player?.backgroundMode = .proceed
        player?.play()
        player?.displayView.delegate = self
        player?.displayView.titleLabel.text = ""
        player?.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.edges.equalTo(strongSelf.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
}

extension VideoPlayerViewConntrollerViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension VideoPlayerViewConntrollerViewController: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
           // self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}
