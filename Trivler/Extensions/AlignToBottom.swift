//
//  AlignToBottom.swift
//  Trivler
//
//  Created by Tej Guntuku on 7/19/21.
//

import UIKit

class VerticalAlignedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height - 20
        case .bottom:
            let height = sizeThatFits(rect.size).height + 20
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        
        super.drawText(in: newRect)
    }
}
