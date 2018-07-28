//
//  MarketPhotoController.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit
class MarketPhotosController: UIViewController{
    
    
  /*  The overlayview displayed over photos */
    
    var overlayView: MarketPhotoOverlayView = MarketPhotoOverlayView(frame: .zero){
        willSet{
            overlayView.view().removeFromSuperview()
        }
        didSet{
            overlayView.photosViewController = self
            overlayView.view().autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayView.view().frame = view.bounds
            view.addSubview(overlayView.view())
        }
    }
    
    private(set) lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleSingleTapGestureRecognizer(_:)))
    }()
    
    var currentPhotoViewController: MarketPhotoViewController?{
        return pageViewController.viewControllers?.first as? MarketPhotoViewController
    }
    
    var currentPhoto: MarketPhotoViewable?{
        return currentPhotoViewController?.photo
    }

    private (set) var pageViewController: UIPageViewController!
    private (set) var dataSource: MarketGalleryDataSource
    
    
    private var statusBarHidden = false
    
    init(photos: [MarketPhotoViewable],initialPhoto: MarketPhotoViewable? = nil, referenceView: UIView? = nil){
        dataSource = MarketGalleryDataSource(photos: photos)
        super.init(nibName : nil, bundle : nil)
        initialSetupWithInitialPhoto(initialPhoto)
        // starting view and ending View
    }
    
    
    private func initialSetupWithInitialPhoto(_ initialPhoto: MarketPhotoViewable? = nil){
        overlayView.photosViewController = self
        setupPageViewControllerWithInitialPhoto(initialPhoto)
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.tintColor = UIColor.white
        pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        pageViewController.didMove(toParentViewController: self)
        
        setupOverlayView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        updateCurrentPhotosInformation()
    }
    
    private func setupPageViewControllerWithInitialPhoto(_ initialPhoto: MarketPhotoViewable? = nil){
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 16.0])
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let photo = initialPhoto, dataSource.contains(photo){
            changeToPhoto(photo, animated: false)
        } else if let photo = dataSource.photos.first{
            changeToPhoto(photo, animated: false)
        }
        
    }
    
    private func setupOverlayView(){
        overlayView.view().autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlayView.view().frame = view.bounds
        view.addSubview(overlayView.view())
        overlayView.setHidden(false, animated: false)
    }
    
    func changeToPhoto(_ photo: MarketPhotoViewable, animated: Bool, direction: UIPageViewControllerNavigationDirection = .forward){
        if !dataSource.contains(photo){ return }
        let photoViewController = initializePhotoViewController(with: photo)
        pageViewController.setViewControllers([photoViewController], direction: direction, animated: animated, completion: nil)
        updateCurrentPhotosInformation()
    }
    
    func initializePhotoViewController(with photo: MarketPhotoViewable) -> MarketPhotoViewController{
        let controller = MarketPhotoViewController()
        controller.photo = photo
        return controller
    }
    
    private func updateCurrentPhotosInformation(){
        if let currentPhoto = currentPhoto{
            overlayView.populateWithPhoto(currentPhoto)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        if let parentStatusBarHidden = presentingViewController?.prefersStatusBarHidden, parentStatusBarHidden {
            return parentStatusBarHidden
        }
        return statusBarHidden
    }
 
    
    @objc
    private func handleSingleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        overlayView.setHidden(!overlayView.view().isHidden, animated: true)
    }
    
    
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.dataSource = MarketGalleryDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = MarketGalleryDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
    }
}

extension MarketPhotosController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateCurrentPhotosInformation()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let controller = viewController as? MarketPhotoViewController, let pht = controller.photo, let photoIndex = dataSource.indexOfPhoto(pht), let newPhoto = dataSource[photoIndex-1] else {
            return nil
        }
        return initializePhotoViewController(with: newPhoto)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? MarketPhotoViewController, let pht = controller.photo, let photoIndex = dataSource.indexOfPhoto(pht), let newPhoto = dataSource[photoIndex + 1] else {
            return nil
        }
        return initializePhotoViewController(with: newPhoto)
    }
}





