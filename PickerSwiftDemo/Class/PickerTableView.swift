//
//  PickerTableView.swift
//  PickerSwiftDemo
//
//  Created by os on 2019/11/27.
//  Copyright © 2019 os. All rights reserved.
//

import UIKit

class PickerTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = UIColor.clear
        self.scrollsToTop = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
