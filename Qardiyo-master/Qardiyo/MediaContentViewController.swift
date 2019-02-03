//
//  MediaContentViewController.swift
//  QardiyoHF
//
//  Created by Shivam Chauhan on 15/04/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit

class MediaContentViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()

        // Do any additional setup after loading the view.
    }
    
    func initUI() {
    
        imageView.image = image
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    
    func loadImage() {
        // This is run in the callback when the full image has been loaded (image = UIImage)
       
        self.scrollView!.contentSize = image.size
        
        let imgwidth = CGFloat(self.view.bounds.size.width / image.size.width)
        let imgheight = CGFloat(self.view.bounds.size.height / image.size.height)
        let minZoom: CGFloat = min(imgwidth, imgheight)
        
        NSLog("image size: %@ / %f", NSStringFromCGSize(image.size), minZoom)
        
        if (minZoom <= 1) {
            self.scrollView!.minimumZoomScale = minZoom
            self.scrollView!.setZoomScale(minZoom, animated: false)
            self.scrollView!.zoomScale = minZoom
        }
    }
    
    // delegates:
    func zoom(tapGesture: UITapGestureRecognizer) {
        if (self.scrollView!.zoomScale == self.scrollView!.minimumZoomScale) {
            let center = tapGesture.location(in: self.scrollView!)
            let size = self.imageView.image!.size
            let zoomRect = CGRect(x: center.x, y: center.y, width: size.width / 2, height: size.height / 2)// CGRectMake(center.x, center.y, (size.width / 2), (size.height / 2))
            self.scrollView!.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView!.setZoomScale(self.scrollView!.minimumZoomScale, animated: true)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
