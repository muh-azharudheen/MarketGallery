//
//  MarketPhotoOverlayViewable.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit

protocol MarketPhotoOverlayViewable: class {
    var photosViewController: MarketPhotosController? { get set}
    
    func populateWithPhoto(_ photo: MarketPhotoViewable)
    
    func setHidden(_ hidden: Bool, animated: Bool)
    
    func view() -> UIView
}

extension MarketPhotoOverlayViewable where Self: UIView{
    func view() -> UIView {
        return self
    }
}

class MarketPhotoOverlayView: UIView, MarketPhotoOverlayViewable{
    
    private(set) var navigationBar: UINavigationBar!
    
    open private(set) var navigationItem: UINavigationItem!
    
    var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    
    private var topShadow: CAGradientLayer!
    private var bottomShadow: CAGradientLayer!
    
    
    private var currentPhoto: MarketPhotoViewable?
    
    var photosViewController: MarketPhotosController?{
        didSet{
            pageControl.numberOfPages = photosViewController!.dataSource.numberOfPhotos
        }
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupShadows()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        setupNavigationBar()
        setupPageControl()
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        
        
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 50).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.barTintColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem = UINavigationItem(title: "")
        navigationBar.items = [navigationItem]
        
        addSubview(navigationBar)
        
        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        } else {
            topConstraint = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        }
        let widthConstraint = NSLayoutConstraint(item: navigationBar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        let horizontalPositionConstraint = NSLayoutConstraint(item: navigationBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topConstraint,widthConstraint,horizontalPositionConstraint])
        
        
        leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonTapped))
        
    }
    
    private func setupPageControl(){
        addSubview(pageControl)
        
        
        if #available(iOS 11.0, *) {
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        } else {
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        }
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        
    }
    
    private func setupShadows(){
        let startColor = UIColor.black.withAlphaComponent(0.5)
        let endColor = UIColor.clear
        
        self.topShadow = CAGradientLayer()
        topShadow.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.insertSublayer(topShadow, at: 0)
        
        self.bottomShadow = CAGradientLayer()
        bottomShadow.colors = [endColor.cgColor, startColor.cgColor]
        self.layer.insertSublayer(bottomShadow, at: 0)
        
        updateShadowFrames()
    }
    
    private func updateShadowFrames(){
        topShadow.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        bottomShadow.frame = CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width, height: 60)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowFrames()
    }
    
    func populateWithPhoto(_ photo: MarketPhotoViewable) {
        self.currentPhoto = photo
        if let controller = photosViewController, let index = controller.dataSource.indexOfPhoto(photo){
            titleLabel.text = photo.title
            pageControl.currentPage = index
        }
        
    }
    
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if self.isHidden == hidden {
            return
        }
        if animated {
            self.isHidden = false
            self.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { () -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: { result in
                self.alpha = 1.0
                self.isHidden = hidden
            })
        } else {
            self.isHidden = hidden
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView != self{
            return hitView
        }
        return nil
    }
    
    @objc
    private func closeButtonTapped(){
        photosViewController?.dismiss(animated: true, completion: nil)
    }
    
}


extension UIPageControl {
    
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}
