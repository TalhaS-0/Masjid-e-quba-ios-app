//
//  WelcomeVC.swift
//  Masjid-e-Quba
//
//  Created by Muhammad Shahrukh on 20/04/2022.
//

import UIKit
import CenteredCollectionView

class WelcomeVC: UIViewController {
    
    var collectionViewLayout: UICollectionViewFlowLayout!

    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WelcomeCollectionVC", bundle: nil), forCellWithReuseIdentifier: "WelcomeCVC")

//        if #available(iOS 10.0, *) {collectionView.isPrefetchingEnabled = false}
        collectionViewLayout = collectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
//
//        // Modify the collectionView's decelerationRate (REQURED)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionViewLayout.itemSize = CGSize(
            width: view.frame.width,
            height: collectionView.frame.height
        )
//        // Configure the optional inter item spacing (OPTIONAL)
        collectionViewLayout.minimumLineSpacing = 20
//        // Do any additional setup after loading the view.
        
        
        
        //Page control
        pageControl.numberOfPages = 3
        
        //Start Button
        startBtn.layer.borderWidth = 2
        startBtn.layer.borderColor = UIColor.darkGray.cgColor
        startBtn.layer.cornerRadius = 10
    }
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
    }
    @IBAction func startBtnTapped(_ sender: UIButton) {
        
    }
    
}
extension WelcomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // MARK: - Number of Items in section Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // MARK: - Cell for Item on indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCVC", for: indexPath) as! WelcomeCollectionVC

        
        cell.imageView.image = UIImage(named: "AppIcon")
        cell.welcomeLbl.text = "Welcome"
        cell.textLbl.text = "to new Masjid-e-Quba App"
        
        return cell
    }
    
    
    // MARK: - Flowlayout delegate to set size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width  = view.frame.width
        let height = collectionView.frame.height
       
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}

