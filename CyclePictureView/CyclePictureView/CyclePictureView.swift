//
//  CyclePictureView.swift
//  CyclePictureView
//
//  Created by Panda on 2017/7/6.
//  Copyright © 2017年 MooneyWang. All rights reserved.
//

import UIKit

protocol CyclePictureViewDelegate: class {
    func cyclePictureViewDidSelectAt(index: Int)
}

class CyclePictureView: UIView, UIScrollViewDelegate {

    private weak var imageScrollView: UIScrollView!
    private weak var leftImageView: UIImageView!
    private weak var centerImageView: UIImageView!
    private weak var rightImageView: UIImageView!
    private weak var pageController: UIPageControl!
    private var timer = Timer()
    private var currentIndex: Int = 0 {
        didSet {
            updateImage()
            pageController.currentPage = currentIndex
        }
    }
    var imageNames: [String] = [] {
        didSet {
            updateImage()
            if imageNames.count == 1 {
                imageScrollView.isScrollEnabled = false
                pageController.isHidden = true
            } else {
                imageScrollView.isScrollEnabled = true
                pageController.isHidden = false
                pageController.currentPage = currentIndex
                pageController.numberOfPages = imageNames.count
                startTimer()
            }
        }
    }
    weak var delegate: CyclePictureViewDelegate?

    // MARK: - override methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageScrollView.frame = self.bounds
        imageScrollView.contentSize = CGSize(width: self.bounds.width * 3, height: 0)
        imageScrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        leftImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        centerImageView.frame = CGRect(x: self.bounds.width, y: 0, width: self.bounds.width, height: self.bounds.height)
        rightImageView.frame = CGRect(x: self.bounds.width * 2, y: 0, width: self.bounds.width, height: self.bounds.height)
        pageController.frame = CGRect(x: 0, y: self.bounds.height - 20, width: self.bounds.width, height: 0)
    }

    // MARK: - private methods

    private func setup() {
        setupScrollView()
        setupImageView()
        setupPageControl()
    }

    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        imageScrollView = scrollView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        imageScrollView.addGestureRecognizer(tapGesture)
    }

    private func setupImageView() {
        for i in 0..<3 {
            let imageView = UIImageView()
            imageScrollView.addSubview(imageView)
            switch i {
            case 0:
                leftImageView = imageView
            case 1:
                centerImageView = imageView
            case 2:
                rightImageView = imageView
            default:
                break
            }
        }
    }

    private func setupPageControl() {
        let pageIndicator = UIPageControl()
        self.addSubview(pageIndicator)
        pageController = pageIndicator
    }

    private func updateImage() {
        if currentIndex <= 0 {
            leftImageView.image = UIImage(named: imageNames[imageNames.count - 1])
        } else {
            leftImageView.image = UIImage(named: imageNames[currentIndex - 1])
        }
        centerImageView.image = UIImage(named: imageNames[currentIndex])
        if currentIndex >= imageNames.count - 1 {
            rightImageView.image = UIImage(named: imageNames[0])
        } else {
            rightImageView.image = UIImage(named: imageNames[currentIndex + 1])
        }
    }

    private func leftScrollIndex() -> Int {
        var result: Int
        if currentIndex >= 1 {
            result = currentIndex - 1
        } else {
            result = imageNames.count - 1
        }
        return result
    }

    private func rightScrollIndex() -> Int {
        var result: Int
        if currentIndex <= imageNames.count - 2 {
            result = currentIndex + 1
        } else {
            result = 0
        }
        return result
    }

    private func updetaScrollView() {
        let realContentOffset = imageScrollView.contentOffset
        if realContentOffset.x / self.bounds.width == 0.0 {
            currentIndex = leftScrollIndex()
            imageScrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        } else if realContentOffset.x / self.bounds.width == 2.0 {
            currentIndex = rightScrollIndex()
            imageScrollView.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (_) in

            self.imageScrollView.setContentOffset(CGPoint(x: self.bounds.width * 2, y: 0), animated: true)
            self.updetaScrollView()

        })
    }

    private func stopTimer() {
        timer.invalidate()
    }

    @objc private func tapAction() {
        if let delegate = delegate {
            delegate.cyclePictureViewDidSelectAt(index: pageController.currentPage)
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let realContentOffset = scrollView.contentOffset
        let offWidth = realContentOffset.x / self.bounds.width
        if offWidth <= 0.5 {
            pageController.currentPage = leftScrollIndex()
        } else if offWidth >= 1.5 {
            pageController.currentPage = rightScrollIndex()
        } else {
            pageController.currentPage = currentIndex
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updetaScrollView()
        startTimer()
    }
}
