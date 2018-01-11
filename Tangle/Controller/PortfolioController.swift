//
//  ViewController.swift
//  Tangle
//
//  Created by Michael Lema on 1/11/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

class PortfolioController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let cellId = "cellId"
    
    let priceButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 42)
        button.setTitle("$19,450.75", for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(handlePriceButton), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        return cv
    }()
    
    //: MARK: - Button actions
    @objc func handlePriceButton() {
        print("handlePriceButton was tapped!")
    }
    
    //: MARK: - Set Up Views
    func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false

        view.addSubview(priceButton)
        //view.addConstraintsWithFormat(format: "H:|[v0]|", views: priceButton)
        view.addConstraint(NSLayoutConstraint(item: priceButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraintsWithFormat(format: "V:|-50-[v0(50)]", views: priceButton)
        
        //: Addding the collection view to the cell
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|-105-[v0]|", views: collectionView)
        
    }

    //: MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //: Light Blue Color
        view.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 182)
        setupViews()
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: PortfolioController.cellId)
    }

    //: MARK: - CollectionView methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioController.cellId, for: indexPath) as! CoinCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 25, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //: TODO: - Hide navigation Bar for now.
        self.navigationController?.navigationBar.isHidden = true
    }
}

