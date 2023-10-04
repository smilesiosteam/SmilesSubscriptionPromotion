//
//  SmilesSubscriptionDetailsVC.swift
//  
//
//  Created by Shmeel Ahmad on 04/10/2023.
//


import Foundation
import UIKit
import LottieAnimationManager
import SmilesUtilities
import SmilesSharedServices
import NetworkingLayer
import Combine

public class SmilesSubscriptionDetailsVC: UIViewController {
    var offer: BOGODetailsResponseLifestyleOffer?
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
    
    @IBOutlet weak var tryNowBtn: UIButton!
    @IBOutlet weak var tryNowView: UIView!

    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    // MARK: Properties

    var shortTitle : String?
    @objc var bogoEventName: String = ""
    @objc var shouldShowLeftButtons = false
    public var isGuestUser: Bool = false
    public var showBackButton: Bool = false
    lazy  var backButton: UIButton = UIButton(type: .custom)
    
    @IBOutlet weak var tableViewBottomToEnterGiftView: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToSuperView: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    private var input: PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesSubscriptionPromotionViewModel = {
        return SmilesSubscriptionPromotionViewModel()
    }()
    var benefitsResponse:SubscriptionDetailsResponse?{
        didSet{
            self.reloadData()
        }
    }
    
    // MARK: Lifecycle
    public  init() {
        super.init(nibName: "SmilesSubscriptionDetailsVC", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        self.setupTableViewCells()
        subscriptionSubTitleLbl.fontTextStyle = .smilesBody3
        subscriptionTitleLbl.fontTextStyle = .smilesHeadline1
        subscriptionDescLbl.fontTextStyle = .smilesHeadline4
        self.tryNowView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true // change me!!!

        self.bind(to: viewModel)
        self.setUpNavigationBar(showBackButton)
//        if !self.shouldShowLeftButtons {
//            leftSideButtons = nil
//        }
        
        
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
        self.input.send(.getSubscriptionDetails(offer?.subscriptionSegment ?? ""))
    }
    private func setUpNavigationBar(_ showBackButton: Bool = false) {
       
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let locationNavBarTitle = UILabel()
//        if self.SmilesSubscriptionPromotionSourceScreen == .other {
//            locationNavBarTitle.text = self.response?.themeResources?.explorerSubscriptionTitle ?? "Success".localizedString
//        } else {
//            locationNavBarTitle.text = "Success".localizedString
//        }
        
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        locationNavBarTitle.textColor = .appRevampPurpleMainColor
        

        self.navigationItem.titleView = locationNavBarTitle
        /// Back Button Show
        
            self.backButton = UIButton(type: .custom)
            // btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
            self.backButton.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "purple_back_arrow_ar" : "purple_back_arrow", in: .module, compatibleWith: nil), for: .normal)
            self.backButton.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
            self.backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            self.backButton.layer.cornerRadius = self.backButton.frame.height / 2
            self.backButton.clipsToBounds = true
            
            let barButton = UIBarButtonItem(customView: self.backButton)
            self.navigationItem.leftBarButtonItem = barButton
        if (!showBackButton) {
            self.backButton.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }

    func bind(to viewModel: SmilesSubscriptionPromotionViewModel) {
        input = PassthroughSubject<SmilesSubscriptionPromotionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionPromotionsDidSucceed(_):
                    break
                case .fetchSubscriptionPromotionsDidFail(_):
                    break
                case .fetchSubscriptionDetailsDidSucceed(let response):
                    self?.benefitsResponse = response
                case .fetchSubscriptionDetailsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupUI() {
       
       // viewHeader.frame = CGRect.init(x: viewHeader.frame.origin.x, y: viewHeader.frame.origin.y, width: viewHeader.frame.size.width, height: 88)
        self.headerView.isHidden = false
        self.headerViewHeight.constant = 270
        self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
        self.view.layoutIfNeeded()
        
        
       // self.ytPopUpView.isHidden = true
       // self.ytPopUpView.ytViewDelegate = self
        tryNowBtn.titleLabel?.fontTextStyle = .smilesHeadline4
        tryNowBtn.setTitle("EnterGiftDetails".localizedString, for: .normal)
        
    }
    
    func reloadData(){
        self.tableView.reloadData()
    }
    func setupTableViewCells() {
        tableView.registerCellFromNib(SubscriptionDetailsCell.self, withIdentifier: String(describing: SubscriptionDetailsCell.self), bundle: .module)
    }
    
    @IBAction func tryNowButtonTapped(_ sender: Any) {
       
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
            self.shortTitle = response.themeResources?.lifestyleShortTitle.asStringOrEmpty()
            self.subscriptionLogo.setImageWithUrlString(response.themeResources?.lifestyleLogoUrl ?? "")
            self.subscriptionSubTitleLbl.text = response.themeResources?.lifestyleTitle.asStringOrEmpty()
            self.subscriptionTitleLbl.text = shortTitle
            self.subscriptionDescLbl.text = response.themeResources?.lifestyleSubTitle.asStringOrEmpty()
            self.tryNowView.isHidden = false
            if isGuestUser {
                self.tryNowView.isHidden = true
                self.tableViewBottomToEnterGiftView.priority = .defaultLow
                self.tableViewBottomToSuperView.priority = .defaultHigh
            }
            self.tableView.reloadData()
        }
    }
    
}

