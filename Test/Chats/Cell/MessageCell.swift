//
//  MessageCell.swift
//  Test
//
//  Created by Kseniya Zharikova on 25/10/23.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    @IBOutlet weak var massageNumber: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    
    override func systemLayoutSizeFitting(
           _ targetSize: CGSize,
           withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
           verticalFittingPriority: UILayoutPriority) -> CGSize {
           var targetSize = targetSize
           targetSize.height = CGFloat.greatestFiniteMagnitude
           let size = super.systemLayoutSizeFitting(
               targetSize,
               withHorizontalFittingPriority: .required,
               verticalFittingPriority: .fittingSizeLevel
           )
           return size
       }
    
    func fill(message: String, messageNumber: Int) {
        massageNumber.text = "Message: \(messageNumber)"
        messageLabel.text = message
    }
}
