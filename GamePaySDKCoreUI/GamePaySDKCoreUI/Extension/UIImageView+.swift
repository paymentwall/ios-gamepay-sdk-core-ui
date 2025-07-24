//
//  UIImageView+.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

import UIKit

private var imageURLKey: UInt8 = 0

extension UIImageView {
    // Important: UITableViewCell reuse can cause image mismatches when scrolling fast.
    // Asynchronous image loading might complete after the cell has been reused for a different item,
    // causing the wrong image to appear briefly.
    //
    // To fix this, we track the expected URL with `currentImageURL`.
    // When the image finishes loading, we only assign it if the URL matches the one currently expected.
    // This prevents showing incorrect images due to async timing issues during fast scrolling.

    private var currentImageURL: String? {
        get { objc_getAssociatedObject(self, &imageURLKey) as? String }
        set { objc_setAssociatedObject(self, &imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        self.currentImageURL = urlString
        
        ImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            
            if self.currentImageURL == urlString {
                self.image = image
            }
        }
    }
}
