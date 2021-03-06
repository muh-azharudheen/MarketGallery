//
//  ViewController.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit






class ViewController: UICollectionViewController {

//    private var dataSource: [MarketPhoto] = [MarketPhoto(#imageLiteral(resourceName: "ozil1"), title: "Mesut Ozil 1"),MarketPhoto(#imageLiteral(resourceName: "ozil4"), title: "Mesut Ozil 2"),MarketPhoto(#imageLiteral(resourceName: "ozil3"), title: "Mesut Ozil 3"),MarketPhoto(#imageLiteral(resourceName: "unnamed"), title: "Muhammed Azharudheen \n nbjkbjk Muhammed Azharudheen Muhammed Azharudheen Muhammed Azharudheen"),MarketPhoto(#imageLiteral(resourceName: "ozil2"), title: "Mesut Ozil 4")]
    
    
    private var dataSource : [MarketPhoto] = [ MarketPhoto(imageURL: "https://d2x51gyc4ptf2q.cloudfront.net/content/uploads/2017/11/06143553/Mesut-Ozil-700x367.jpg", title: "Hello"),
                                       MarketPhoto(imageURL: "https://d3nfwcxd527z59.cloudfront.net/content/uploads/2017/11/20073750/Mesut-Ozil-Arsenal.jpg", title: "Hello"),
                                       MarketPhoto(imageURL: "https://pbs.twimg.com/media/CwvwL0gWEAQP44O.jpg", title: "Hello"),
                                       MarketPhoto(imageURL: "https://d.ibtimes.co.uk/en/full/430561/mesut-ozil.jpg", title: "Hello"),
                                       MarketPhoto(imageURL: "https://dj0j0ofql4htg.cloudfront.net/cms2/image_manager/uploads/News/299128/7/default.jpg", title: "Hello")
                                       
                                       
                                       ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        print("Hello")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = dataSource[indexPath.item].image
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let initialPhoto  = dataSource[indexPath.item]
        let gallery = MarketPhotosController(photos: dataSource, initialPhoto: initialPhoto, referenceView: nil)
        self.present(gallery, animated: true)
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        if let image = dataSource[indexPath.item].image {
            height = (image.size.height / image.size.width) * self.view.frame.width
  
        }
        
        return CGSize(width: self.view.frame.width, height: height)
    }
}

class ImageCell: UICollectionViewCell{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        imageView.backgroundColor = UIColor.lightGray
    }
    
    private func setupViews(){
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            ])
        
    }
    
}

