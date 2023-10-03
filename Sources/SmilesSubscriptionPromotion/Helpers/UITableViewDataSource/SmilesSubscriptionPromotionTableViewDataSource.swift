//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 03/10/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices


extension SmilesSubscriptionPromotionVC: UITableViewDataSource, UITableViewDelegate {
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmilesSubscriptionPromotionCell", for: indexPath) as! SmilesSubscriptionPromotionCell
        return cell
    }


    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }

    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
    
}

