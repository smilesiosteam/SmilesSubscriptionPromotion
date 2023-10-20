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
import Combine
import SmilesYoutubePopUpView


public class SmilesSubscriptionPromotionVC: UIViewController,SmilesSubscriptionButtonCellDelegate {
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
    
    @IBOutlet public var emptyDealsContainer: UIView!

    @IBOutlet var eligiblityImageView: UIImageView!
    @IBOutlet var eligiblityMsgLabelView: UILabel!

    @IBOutlet weak var giftCardBtn: UIButton!
    @IBOutlet weak var enterGiftCardView: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewHeaderTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonHeader: UIButton!
    
    

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    // MARK: Properties

   // var presenter: SubscriptionRevampPresentation?
    var shortTitle : String?
   // private var view_eligiblity = EligibilityView.setUpView()
    @objc var bogoEventName: String = ""
    private var isGuestUser: Bool = false
    private var showBackButton: Bool = false
     var isDummy: Bool = true
    var videoPlayerObj: SmilesSubsciptionVideoTutorial?
    private var delegate: SmilesSubscriptionPromotionDelegate?
    
    @IBOutlet weak var emptyContainerTopConstraint: NSLayoutConstraint!
    
   
    //MARK: - Youtube Popup vars
    @IBOutlet var ytPopUpView: SmilesYoutubePopUpView!
    @IBOutlet weak var constraint_videoPlayerWidth: NSLayoutConstraint!
    @IBOutlet weak var constraint_videoPlayerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomToEnterGiftView: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToSuperView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesSubscriptionPromotionViewModel = {
        return SmilesSubscriptionPromotionViewModel()
    }()
     var response:SmilesSubscriptionBOGODetailsResponse?
    
    
    // MARK: Lifecycle
    public  init(showBackButton: Bool = false,isGuestUser: Bool,delegate: SmilesSubscriptionPromotionDelegate?) {
        self.delegate = delegate
        self.isGuestUser = isGuestUser
        self.showBackButton = showBackButton
        super.init(nibName: "SmilesSubscriptionPromotionVC", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        
        self.setupTableViewCells()
        subscriptionSubTitleLbl.fontTextStyle = .smilesBody3
        subscriptionTitleLbl.fontTextStyle = .smilesHeadline1
        subscriptionDescLbl.fontTextStyle = .smilesHeadline4
        viewHeaderTitle.fontTextStyle = .smilesHeadline4
        
        self.bind(to: viewModel)
       
        if self.showBackButton {
            backButton.isHidden = false
            self.backButtonHeader.isHidden = false
        }
                
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        self.input.send(.getSubscriptionPromotions)
        self.input.send(.getVideoTutorials)
       // presenter?.viewWillAppear(bogoEventName: self.bogoEventName)
    }
    
    func bind(to viewModel: SmilesSubscriptionPromotionViewModel) {
        input = PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case.fetchVideoTutorialsDidSucceed(let videos):
                    self?.showTutorialView(with: videos.videoTutorial)
                case.fetchVideoTutorialsDidFail(let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchSubscriptionPromotionsDidSucceed(let response):
                    DispatchQueue.main.async {
                        self?.response = response
                        self?.updateViewWith(response: self?.response)
                    }
                case .fetchSubscriptionDetailsDidSucceed:
                    break
                case .fetchSubscriptionDetailsDidFail:
                    break
                case .fetchSubscriptionPromotionsDidFail(error: _):
                    self?.didFetchedBogoDetailsWithFailureResponse()
                }
            }.store(in: &cancellables)
    }
    @objc public func reloadHome() {
        self.input.send(.getSubscriptionPromotions)
      //  presenter?.viewWillAppear(bogoEventName: self.bogoEventName)
    }
    
    func setupUI() {
        
        self.subscriptionSubTitleLbl.text = "Smiles Unlimited"
        self.subscriptionTitleLbl.text = "Smiles Unlimited"
        self.subscriptionDescLbl.text = "Subscribe and save more"
        
//        headerView.enableSkeleton()
//        headerView.showAnimatedSkeleton()
        
        self.backButton.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "backIconWhiteAr" : "backIconWhite", in: .module, compatibleWith: nil), for: .normal)
        self.backButtonHeader.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "backIconWhiteAr" : "backIconWhite", in: .module, compatibleWith: nil), for: .normal)
        
       //  viewHeader.frame = CGRect.init(x: viewHeader.frame.origin.x, y: viewHeader.frame.origin.y, width: viewHeader.frame.size.width, height: 88)
        
       
        self.headerView.isHidden = false
        self.headerViewHeight.constant = 270
        self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
        self.view.layoutIfNeeded()
        viewHeader.addGradientColors(UIColor.navigationGradientColorArray(), opacity: 1.0, direction: .diagnolLeftToRight)
        emptyDealsContainer.isHidden = true
        
       self.ytPopUpView.isHidden = true
       self.ytPopUpView.ytViewDelegate = self
        giftCardBtn.titleLabel?.fontTextStyle = .smilesHeadline4
        giftCardBtn.setTitle("EnterGiftDetails".localizedString, for: .normal)
    }
    
    func setupTableViewCells() {
        tableView.registerCellFromNib(SmilesSubscriptionPromotionCell.self, withIdentifier: String(describing: SmilesSubscriptionPromotionCell.self), bundle: .module)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let delegate = self.delegate {
            delegate.checkEligiblity()
        }
    }
    
    // MARK: - IBActions
    @IBAction  func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func enterGiftCardTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.navigateEnterGiftCard()
        }
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
       // presenter?.navigateToScanQrController()
//        let vc = SmilesSubscriptionPromotionRouter.shared.pushAndGetLifestyleDetails(navVC: self.navigationController!) as! SmilesSubscriptionDetailsVC
//        vc.offer = response?.lifestyleOffers?.first
        if let delegate = delegate {
            delegate.navigateToScanQrController()
        }
    }
    
    private func changeNavigationBarStyleWhileScrolling(intialState: Bool, withTitle title: String) {
        DispatchQueue.main.async {
           // self.setHeaderWithWhiteTitle(title)
        }
        
        //backButton.RoundedViewConrner(cornerRadius: 12.0)
        if intialState {
            //headerView.backgroundColor = .clear
           // backButton.backgroundColor = .white
            //viewHeader.removeGradientColor()
           
        }
        else {
            viewHeader.addGradientColors(UIColor.navigationGradientColorArray(), opacity: 1.0, direction: .diagnolLeftToRight)

            //setHeaderGardientColor()
           
        }
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
            self.headerView.hideSkeleton()
            self.isDummy = false
            self.emptyDealsContainer.isHidden  = true
            self.shortTitle = response.themeResources?.lifestyleShortTitle.asStringOrEmpty()
            self.subscriptionLogo.setImageWithUrlString(response.themeResources?.lifestyleLogoUrl ?? "")
            self.subscriptionSubTitleLbl.text = response.themeResources?.lifestyleTitle.asStringOrEmpty()
            self.subscriptionTitleLbl.text = shortTitle
            self.subscriptionDescLbl.text = response.themeResources?.lifestyleSubTitle.asStringOrEmpty()
            self.viewHeaderTitle.text = self.shortTitle
            self.enterGiftCardView.isHidden = false
            if isGuestUser {
                self.enterGiftCardView.isHidden = true
                self.tableViewBottomToEnterGiftView.priority = .defaultLow
                self.tableViewBottomToSuperView.priority = .defaultHigh
            }
            self.tableView.reloadData()
            
        }
    }
    func showTutorialView(with videoPlayer: SmilesSubsciptionVideoTutorial?) {
        
        self.videoPlayerObj = videoPlayer
        if let thumbNail = videoPlayer?.thumbnailImageURL, !thumbNail.isEmpty {
            DispatchQueue.main.async {
                self.ytPopUpView.isHidden = false
                self.ytPopUpView.thumbImgView.setImageWithUrlString(thumbNail)
            }
        } else {
            self.ytPopUpView.isHidden = true
        }
    }
    func subscribeDidTapped(model: BOGODetailsResponseLifestyleOffer) {
        if (model.isSubscription ?? false) {
//            let vc = SmilesSubscriptionPromotionConfigurator.create(type: .CancelSubscriptionFeedBack) as! SubscriptionCancelFeedBackViewController
//            vc.offer = model
//            vc.response = self.response
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = SmilesSubscriptionPromotionConfigurator.create(type: .smilesManageSubscriptionPop(bogoResponse: self.response!, offer: model, delegate: self.delegate, onDismiss: {
                let vc = SmilesSubscriptionPromotionConfigurator.create(type: .SubscriptionDetails(isGuestUser: false, bogoResponse: self.response!, offer: model, delegate: self.delegate)) as! SmilesSubscriptionDetailsVC
                        self.navigationController?.pushViewController(vc, animated: true)
            }))
            vc.hidesBottomBarWhenPushed = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        } else {
            let vc = SmilesSubscriptionPromotionConfigurator.create(type: .SubscriptionDetails(isGuestUser: isGuestUser, bogoResponse: self.response!, offer: model, delegate: self.delegate)) as! SmilesSubscriptionDetailsVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func didFetchedBogoDetailsWithFailureResponse() {
        self.isDummy = false
        self.headerView.hideSkeleton()
        self.tableView.reloadData()
        eligiblityImageView.subviews.forEach({ $0.removeFromSuperview() })
        LottieAnimationManager.showAnimation(onView: eligiblityImageView, withJsonFileName: SmilesSbuscriptionPromotionBillsAndRechargeAnimation.BillPaymentNotEligible.rawValue, removeFromSuper: false, loopMode: .playOnce) {_ in
            
        }
        eligiblityMsgLabelView.text = "ServiceFail".localizedString
        emptyDealsContainer.isHidden = false
        self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: "Unlimited Buy 1 Get 1".localizedString)
    }
}

extension SmilesSubscriptionPromotionVC:  SmilesYoutubeViewDelegate {
    public func didTappedClose() {
        ytPopUpView.removeFromSuperview()
        if let delegate = self.delegate {
            delegate.registerPersonalizationEventRequest(urlScheme:nil , offerId:videoPlayerObj?.watchKey ?? "" , bannerType:nil , eventName:"tutorial_video_closed")
        }
//        HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType.asStringOrEmpty(),
//                                                        urlScheme: nil,
//                                                        offerId: videoPlayerObj?.watchKey,
//                                                        bannerType: nil,
//                                                        eventName: "tutorial_video_closed")
    }
    
    public func didTappedExpand() {
                
        constraint_videoPlayerWidth.isActive = false
        constraint_videoPlayerHeight.isActive = false
        
        ytPopUpView.translatesAutoresizingMaskIntoConstraints = false
        
        ytPopUpView.bottomAnchor.constraint(equalTo: (self.navigationController!.view.bottomAnchor), constant: 0).isActive = true
        ytPopUpView.topAnchor.constraint(equalTo: (self.view.topAnchor), constant: 0).isActive = true
        ytPopUpView.leadingAnchor.constraint(equalTo: (self.navigationController?.view.leadingAnchor)!).isActive = true
        ytPopUpView.trailingAnchor.constraint(equalTo: (self.navigationController?.view.trailingAnchor)!).isActive = true
        ytPopUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        
        ytPopUpView.layoutIfNeeded()
        
        //self.tabBarController?.tabBar.isHidden = true

        self.ytPopUpView.superview?.bringSubviewToFront(self.ytPopUpView)

        ytPopUpView.playVideo(videoURL: videoPlayerObj?.videoURL)
        if let delegate = self.delegate {
            delegate.registerPersonalizationEventRequest(urlScheme:nil , offerId:videoPlayerObj?.watchKey ?? "" , bannerType:nil , eventName:"tutorial_video_played")
        }
//        HouseConfig.registerPersonalizationEventRequest(withAccountType: GetEligibilityMatrixResponse.sharedInstance.accountType.asStringOrEmpty(),
//                                                        urlScheme: nil,
//                                                        offerId: videoPlayerObj?.watchKey,
//                                                        bannerType: nil,
//                                                        eventName: "tutorial_video_played")
    }
}
