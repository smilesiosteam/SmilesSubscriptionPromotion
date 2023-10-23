//
//  CancelSubscriptionFeedBackPopUpVC.swift
//  
//
//  Created by Ghullam  Abbas on 23/10/2023.
//

import UIKit
import LottieAnimationManager


protocol SubscriptionCanceledFeedbackViewControllerDeelegate: AnyObject {
    func popToSubscriptionHomeVC()
}

class CancelSubscriptionFeedBackPopUpVC: UIViewController {

    // MARK: Properties
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet var animationView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var canceResponse : CancelSubscriptionResponseModel?
    
    weak var delegate: SubscriptionCanceledFeedbackViewControllerDeelegate?
    
    // MARK: Lifecycle
    init(canceResponse : CancelSubscriptionResponseModel?) {
        self.canceResponse = canceResponse
        super.init(nibName: "CancelSubscriptionFeedBackPopUpVC", bundle: .module)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        self.titleLabel.fontTextStyle = .smilesHeadline2
        self.titleLabel.textColor = .black
        
        self.descriptionLabel.fontTextStyle = .smilesBody2
        self.descriptionLabel.textColor = .black.withAlphaComponent(0.8)
        mainContainerView.clipsToBounds = true
        mainContainerView.layer.cornerRadius = 16
        mainContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        if let response = canceResponse {
            titleLabel.text = response.title
            descriptionLabel.text = response.description
        }
        animateViewWithAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true,animated: false)
    }
    func animateViewWithAnimation(){
        
        LottieAnimationManager.showAnimationForOrders(onView: animationView, withJsonFileName: SubscriptionAnimation.Feedback.rawValue, removeFromSuper: false, loopMode: .playOnce) { _ in
//            self.navigationController?.popToRootViewController()
           
        }
    }
    @IBAction func crossButtonDidTab(_ sender: UIButton) {
        self.dismiss() {
            self.delegate?.popToSubscriptionHomeVC()
        }
        
       // self.dismiss(animated: true)
    }
}


