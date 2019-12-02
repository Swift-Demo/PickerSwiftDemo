//
//  TableViewCell.swift
//  PickerSwiftDemo
//
//  Created by os on 2019/11/27.
//  Copyright © 2019 os. All rights reserved.
//

import UIKit

class PickerColumnCell: UITableViewCell {
    
    lazy var dateLabel:UILabel = {
        let label = UILabel(frame: self.contentView.bounds)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
    }
    
    func showData(_ datas:NSArray,indexPath:IndexPath,offsetCount:Int,component:Int){
        let row = indexPath.row - offsetCount
        if component == 0 {
            self.dateLabel.frame = CGRect(x: 46.5, y: 0, width: 89.5, height: self.contentView.frame.height)
        }else if component == 1 {
            self.dateLabel.frame = CGRect(x: 18, y: 0, width: 64, height: self.contentView.frame.height)
        }
        
        if indexPath.row < offsetCount || row >= datas.count {
            self.dateLabel.text = ""
        }else{
            self.dateLabel.text = datas[row] as? String
        }
    }
    
    func transformWithAngle(angle:CGFloat,scale:CGFloat){
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, angle, 1, 0, 0)
        transform = CATransform3DScale(transform, scale, scale, scale)
        self.layer.transform = transform
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

