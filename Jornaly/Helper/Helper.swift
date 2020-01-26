//
//  Helper.swift
//  Jornaly
//
//  Created by MacBookPro on 1/20/20.
//  Copyright © 2020 MacBookPro. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController : UICollectionViewDelegate {
    

    
    // A helper method that shows an Alert Box containing a given message
    func errorAlert(controller: UIViewController, title: String,message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
    }
    
    // A helper method that calculate the difference between the news date and the device time
    func calculateNewsDate(publishedAt: String) -> String {
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        
        let newsDate = dateFor.date(from: publishedAt)
        let currentDate = Date()
        var timeDifference: String = ""
        
        if let newsDate = newsDate {
            let dateDifference = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: newsDate,to: currentDate)
            
            let year = dateDifference.year ?? 0
            let month = dateDifference.month ?? 0
            let day = dateDifference.day ?? 0
            let hour = dateDifference.hour ?? 0
            let minute = dateDifference.minute ?? 0
            let second = dateDifference.second ?? 0
            
            if year != 0 {
                timeDifference = (year > 1) ? "\(year) years ago" : "\(year) year ago"
            } else if month != 0 {
                timeDifference = (month > 1) ? "\(month) months ago" : "\(month) month ago"
            } else if day != 0 {
                timeDifference = (day > 1) ? "\(day) days ago" : "\(day) day ago"
            } else if hour != 0 {
                timeDifference = (hour > 1) ? "\(hour) hours ago" : "\(hour) hour ago"
            } else if minute != 0 {
                timeDifference = (minute > 1) ? "\(minute) minutes ago" : "\(minute) minute ago"
            } else if second != 0 {
                timeDifference = (second > 1) ? "\(second) seconds ago" : "\(second) second ago"
            }
        }
        return timeDifference
    }
    
    // MARK: Shared Delegate Methods
    
    // Handle opening the news article url
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 10 , left: 50, bottom: 10, right: 50)
    }
    
    
    //open Urls
         func openUrl(_ url: URL) {
             if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 errorAlert(controller: self, title: "Error", message: "Can't Open this url")
             }
         }
}

