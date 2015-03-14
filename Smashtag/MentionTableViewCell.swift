//
//  MentionTableViewCell.swift
//  Smashtag
//
//  Created by chenjs on 15/3/5.
//  Copyright (c) 2015年 TOMMY. All rights reserved.
//

import UIKit

class MentionTableViewCell: UITableViewCell
{
    @IBOutlet weak var mentionLabel: UILabel!

    var mentionText: String? {
        didSet {
            mentionLabel.text = mentionText
        }
    }
}
