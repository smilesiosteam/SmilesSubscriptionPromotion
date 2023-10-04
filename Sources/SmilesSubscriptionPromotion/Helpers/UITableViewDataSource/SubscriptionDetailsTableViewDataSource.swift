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


extension SmilesSubscriptionDetailsVC: UITableViewDataSource, UITableViewDelegate {
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.benefitsResponse?.benefitsList?.count ?? 0
    }

    public  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionDetailsCell", for: indexPath) as! SubscriptionDetailsCell
        cell.updateCell(benefits: benefitsResponse!.benefitsList![indexPath.row])
        return cell
    }


    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
   
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.didScrollTableView(scrollView:scrollView)
    }
}

