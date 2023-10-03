//
//  SmilesSubscriptionPromotionVC.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//


import Foundation
import UIKit
import LottieAnimationManager
import SmilesUtilities
import SmilesSharedServices
import NetworkingLayer

class SmilesSubscriptionPromotionVC: UIViewController {
    @IBOutlet weak var headerViewBottom: UIView! {
        didSet {
            headerViewBottom.layer.cornerRadius = 12
            if #available(iOS 11.0, *) {
                headerViewBottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
                headerViewBottom.isHidden = true
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderGradientView!
    @IBOutlet weak var subscriptionTitleLbl: UILabel!
    @IBOutlet weak var subscriptionSubTitleLbl: UILabel!
    @IBOutlet weak var subscriptionDescLbl: UILabel!
    @IBOutlet weak var subscriptionLogo: UIImageView!
    
    @IBOutlet var emptyDealsContainer: UIView!

    @IBOutlet var eligiblityImageView: UIImageView!
    @IBOutlet var eligiblityMsgLabelView: UILabel!

    @IBOutlet weak var giftCardBtn: UIButton!
    @IBOutlet weak var enterGiftCardView: UIView!

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    // MARK: Properties

   // var presenter: SubscriptionRevampPresentation?
    var shortTitle : String?
   // private var view_eligiblity = EligibilityView.setUpView()
    @objc var bogoEventName: String = ""
    @objc var shouldShowLeftButtons = false
    public var isGuestUser: Bool = false
    //var videoPlayerObj: VideoTutorial?
    
    @IBOutlet weak var emptyContainerTopConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    
    //MARK: - Youtube Popup vars
   // @IBOutlet var ytPopUpView: YoutubePopUpView!
    @IBOutlet weak var constraint_videoPlayerWidth: NSLayoutConstraint!
    @IBOutlet weak var constraint_videoPlayerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomToEnterGiftView: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToSuperView: NSLayoutConstraint!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        subscriptionSubTitleLbl.fontTextStyle = .smilesBody3
        subscriptionTitleLbl.fontTextStyle = .smilesHeadline1
        subscriptionDescLbl.fontTextStyle = .smilesHeadline4
//        setupNavigationBar(withTitle: "", backButtonImg: "", clearHeader: true, rightSideButtons: [])
//        if !self.shouldShowLeftButtons {
//            leftSideButtons = nil
//        }
                
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadHome), name: .ReloadSubHome, object: nil)
        
        super.viewDidLoad()
//        if Constants.DeviceType.hasNotch {
//            emptyContainerTopConstraint.constant = 74
//        } else {
//            emptyContainerTopConstraint.constant = 44
//        }
        
        if let navigationController = self.navigationController {
            if let previousViewController = navigationController.viewControllers[safe: navigationController.viewControllers.count - 2] {
                // Use the previousViewController
                print("Previous View Controller: \(previousViewController)")
              //  Constants.previousController = previousViewController
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
       // presenter?.viewWillAppear(bogoEventName: self.bogoEventName)
    }
    
    @objc func reloadHome() {
      //  presenter?.viewWillAppear(bogoEventName: self.bogoEventName)
    }
    
    func setupUI() {
        setupTableViewCells()
       // viewHeader.frame = CGRect.init(x: viewHeader.frame.origin.x, y: viewHeader.frame.origin.y, width: viewHeader.frame.size.width, height: 88)
        self.headerView.isHidden = false
        self.headerViewHeight.constant = 270
        self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
        self.view.layoutIfNeeded()
        
        emptyDealsContainer.isHidden = true
        
       // self.ytPopUpView.isHidden = true
       // self.ytPopUpView.ytViewDelegate = self
        giftCardBtn.titleLabel?.fontTextStyle = .smilesHeadline4
        giftCardBtn.setTitle("EnterGiftDetails".localizedString, for: .normal)
    }
    
    func setupTableViewCells() {
        
        tableView.registerCellFromNib(SmilesSubscriptionPromotionCell.self, withIdentifier: String(describing: SmilesSubscriptionPromotionCell.self))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if let isEligible = presenter?.isUserEligibleForBOGO(), isEligible {
//            view_eligiblity.frame = emptyDealsContainer.bounds
//        }
    }
    
    @IBAction func enterGiftCardTapped(_ sender: Any) {
       // presenter?.navigateToEnterGiftCardController()
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
       // presenter?.navigateToScanQrController()
    }
    
    private func changeNavigationBarStyleWhileScrolling(intialState: Bool, withTitle title: String) {
        DispatchQueue.main.async {
        //    self.setHeaderWithWhiteTitle(title)
        }
        
 //       backButton?.RoundedViewConrner(cornerRadius: 12.0)
//        if intialState {
//            viewHeader.backgroundColor = .clear
//            backButton?.backgroundColor = .white
//            removeHeaderGardientColor()
//            backButton?.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
//        }
//        else {
//            setHeaderGardientColor()
//            backButton?.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
//        }
    }
    
    func didScrollTableView(scrollView: UIScrollView) {
        if scrollView == tableView {
            var tableViewHeight = tableView.frame.height
            if headerView.isHidden {
                tableViewHeight -= 182
            }
            guard scrollView.contentSize.height > tableViewHeight else { return }
            var compact: Bool?
            if scrollView.contentOffset.y > 90 {
               compact = true
            } else if scrollView.contentOffset.y < 0 {
                compact = false
            }
            guard let compact, compact != headerView.isHidden else { return }
            if compact {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.headerView.isHidden = true
                    self.headerViewHeight.constant = 88
                    self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: self.shortTitle ?? "")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.headerView.isHidden = false
                    self.headerViewHeight.constant = 270
                    self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func updateViewWith(response: SmilesSubscriptionBOGODetailsResponse?) {
        if let response = response {
            self.emptyDealsContainer.isHidden  = true
            self.shortTitle = response.themeResources?.lifestyleShortTitle.asStringOrEmpty()
            self.subscriptionLogo.setImageWithUrlString(response.themeResources?.lifestyleLogoUrl ?? "")
            self.subscriptionSubTitleLbl.text = response.themeResources?.lifestyleTitle.asStringOrEmpty()
            self.subscriptionTitleLbl.text = shortTitle
            self.subscriptionDescLbl.text = response.themeResources?.lifestyleSubTitle.asStringOrEmpty()
            self.enterGiftCardView.isHidden = false
            if isGuestUser {
                self.enterGiftCardView.isHidden = true
                self.tableViewBottomToEnterGiftView.priority = .defaultLow
                self.tableViewBottomToSuperView.priority = .defaultHigh
            }
        }
    }
    
    
    
}

