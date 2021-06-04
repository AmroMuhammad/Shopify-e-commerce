//
//  ProductDetailsTableViewController.swift
//  Shopify e-commerce
//
//  Created by Ahmd Amr on 31/05/2021.
//  Copyright © 2021 ITI41. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import Cosmos

class ProductDetailsTableViewController: UITableViewController {

    
    private var productDetailsViewModel: ProductDetailsViewModel!
    private var disposeBag: DisposeBag!
    
    
    var productId: String!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    private var imagesSubject = PublishSubject<[ProductImage]>()
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    @IBOutlet weak var ratingViewContainer: CosmosView!
    
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    private var colorsSubject = PublishSubject<[UIColor]>()
    
     
    @IBOutlet weak var sizeCollectionView: UICollectionView!

    
    private var sizesSubject = PublishSubject<[String]>()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    @IBOutlet weak var addToCartButtonOutlet: UIButton! // change text clr to green if added??
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        navigationController?.title = "Bean Bag"
        
        productDetailsViewModel = ProductDetailsViewModel()
        disposeBag = DisposeBag()
        
        
        sliderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        colorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        sizeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        let colorNibCell = UINib(nibName: String(describing: ColorViewCollectionViewCell.self), bundle: nil)
        colorsCollectionView.register(colorNibCell, forCellWithReuseIdentifier: Constants.colorCell)
        
        
        imagesSubject.bind(to: sliderCollectionView.rx.items(cellIdentifier: Constants.imageCell)){row, item, cell in
              if let vc = cell.viewWithTag(1) as? UIImageView {
                if let srcImg = item.src{
                    vc.sd_setImage(with: URL(string: srcImg), placeholderImage: UIImage(named: "1"))
                }
            }
        }.disposed(by: disposeBag)
        
        colorsSubject.bind(to: colorsCollectionView.rx.items(cellIdentifier: Constants.colorCell)){row, item, cell in
            print("COLOR BINDDDDDDD")
            let clrCell = cell as! ColorViewCollectionViewCell
            clrCell.lbl.backgroundColor = item
        }.disposed(by: disposeBag)
        
        sizesSubject.bind(to: sizeCollectionView.rx.items(cellIdentifier: Constants.sizeCell)){row, item, cell in
            if let vc = cell.viewWithTag(1) as? UILabel {
                vc.text = item
            }
        }.disposed(by: disposeBag)
        
        
        productDetailsViewModel.sizesObservable.bind { (sizes) in
            print("\n\nObs BIND\n\n")
            self.sizesSubject.onNext(sizes)
        }.disposed(by: disposeBag)
        productDetailsViewModel.colorsObservable.bind { (colors) in
            print("\n\nObs BIND\n\n")
            self.colorsSubject.onNext(colors)
        }.disposed(by: disposeBag)
        productDetailsViewModel.imagesObservable.bind { (images) in
            print("\n\nObs BIND\n\n")
            self.imagesSubject.onNext(images)
            self.pageController.numberOfPages = images.count
        }.disposed(by: disposeBag)

        productDetailsViewModel.productPriceObservable.bind { (price) in
            print("\n\nObs BIND\n\n")
            self.priceLabel.text = price
        }.disposed(by: disposeBag)
        productDetailsViewModel.productTitleObservable.bind { (name) in
            print("\n\nObs BIND\n\n")
            self.productNameLabel.text = name
        }.disposed(by: disposeBag)
        
        
        ratingViewInit()
        
        
        productId = "6687366316230"
        productDetailsViewModel.getProductDetails(id: productId)
        
        currencyLabel.text = "EGP"      // productDetailsViewModel.getCurrency()
        cityNameLabel.text = "Balteem"  // productDetailsViewModel.getDeliverCity()
    }
    
    func ratingViewInit(){
        ratingViewContainer.settings.fillMode = .half
        ratingViewContainer.rating = 3.5
        ratingViewContainer.settings.starSize = Double(tableView.frame.width) / 10
        ratingViewContainer.settings.updateOnTouch = false
        ratingViewContainer.text = "(\(7))"
        ratingViewContainer.settings.textMargin = 10.0
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        print("\n\n\nHEEEEY\n")
        if sender.tag == 0 {
            print("Fav Pressed tag = 0")
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
//            productDetailsViewModel.addToCart()
            
            sender.tag = 1
            
        } else {
            print("Fav Pressed tag = 1")
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
//            productDetailsViewModel.removeFromCart()
            
            sender.tag = 0
        }
        print("\n\n\nBYEEEE\n")
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return view.frame.height * 0.5
            } else {
                return productNameLabel.bounds.height + 25
            }
            
        case 1:
            var val: CGFloat = 0.0
            switch indexPath.row  {
            case 0,2:
                val = 50.0
            case 1:
                val = 70.0
            case 3:
                val = 50.0
            default:
                val = 70.0 //CGFloat.leastNonzeroMagnitude
            }
            return val
        default:
            return 10.0
        }
    }

}

extension ProductDetailsTableViewController: UICollectionViewDelegateFlowLayout {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.bounds.size
        
        switch collectionView.tag {
        case 1:
            return CGSize(width: size.width, height: (size.height))
            
        default:
            return CGSize(width: (size.width - 30) / 4, height: (size.width - 30) / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch collectionView.tag {
        case 1:
            return 0.0
        default:
            return 15.0
        }
    }
    
}