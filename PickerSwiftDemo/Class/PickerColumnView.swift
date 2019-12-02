//
//  PickerColumnView.swift
//  PickerSwiftDemo
//
//  Created by os on 2019/11/27.
//  Copyright © 2019 os. All rights reserved.
//

import UIKit

protocol PickerColumnViewDelegate : NSObjectProtocol {
    func pickerView(pickerView: PickerColumnView, didSelectRow row:Int)
}

class PickerColumnView: UIView {

    var componentIdx:Int?
    var datas:NSArray
    
    var upView:UIView!
    var centerView:UIView!
    var downView:UIView!
    
    weak open var delegate: PickerColumnViewDelegate?
    private var rowHeight:CGFloat = 0
    private var showCount:CGFloat = 1
    private var isSelectedRow:Bool = false
    private var offset:CGFloat = 0
    private var offsetCount:Int = 0
    
    lazy var upTableView:PickerTableView = {
        var frame = self.bounds
        frame.origin.y = -self.offset
        frame.size.height += self.offset
        return setDefalutTableView(frame)
    }()
    
    lazy var centerTableView:PickerTableView = {
        var frame = self.convert(self.upTableView.frame, to: self.centerView)
        return setDefalutTableView(frame)
    }()
    
    lazy var downTableView:PickerTableView = {
        var frame = self.convert(self.upTableView.frame, to: self.downView)
        return setDefalutTableView(frame)
    }()
   
    init(frame:CGRect,rowHeight:CGFloat,isCycleScroll:Bool,datas:NSArray){
        self.rowHeight = rowHeight
        self.datas = datas
        super.init(frame: frame)

        self.showCount = (frame.size.height / rowHeight - 1)/2
        
        let upLineY = (frame.size.height - rowHeight)/2 - 0.5
        let count = Int(upLineY / rowHeight)
        self.offsetCount = count + 1
        self.offset = CGFloat(count + 1) * rowHeight - upLineY
        if self.offset == rowHeight {
            self.offset = 0
        }
        setupView()
    }
    
    func setupView(){
        let upViewHeight = self.frame.size.height/2 - self.rowHeight/2
        let centerViewY = upViewHeight
        let downViewY = centerViewY + self.rowHeight
        self.upView = setDefalutContainerView(CGRect(x: 0, y:0, width: self.frame.size.width, height: upViewHeight))
        self.centerView = setDefalutContainerView(CGRect(x: 0, y: centerViewY, width: self.frame.size.width, height: self.rowHeight))
        self.downView = setDefalutContainerView(CGRect(x: 0, y: downViewY, width: self.frame.size.width, height: self.frame.size.height - downViewY))
        
        self.upView.addSubview(self.upTableView)
        self.centerView.addSubview(self.centerTableView)
        self.downView.addSubview(self.downTableView)
        self.bringSubviewToFront(self.centerTableView)
        
        self.centerTableView.backgroundColor = UIColor(red: 42/255.0, green: 46/255.0, blue: 83/255.0, alpha: 1.0)
        
    }
    func setDefalutContainerView(_ frame:CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        self.addSubview(view)
        return view
    }
    
    func setDefalutTableView(_ frame:CGRect) -> PickerTableView{
        let tableView = PickerTableView(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(PickerColumnCell.self, forCellReuseIdentifier: "PickerColumnCell")
        return tableView
    }
    
    func selectRow(row:Int,animated:Bool){
        if animated {
            let indexPath = IndexPath(row: row, section: 0)
            self.centerTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }else{
            self.centerTableView.contentOffset = CGPoint(x: 0, y: CGFloat(row) * self.rowHeight)
            scrollViewDidEndDecelerating(self.centerTableView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PickerColumnView:UITableViewDelegate,UITableViewDataSource {
    //MARK:UITableViewDelegate
    func numberOfRowsInTableView() -> Int{
        return self.datas.count + self.offsetCount * 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInTableView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if numberOfRowsInTableView() - 1 == indexPath.row {
            let upLineY = (frame.size.height - rowHeight)/2
            let temp = CGFloat(self.offsetCount) * self.rowHeight - upLineY - 0.5
            return abs(temp - self.rowHeight)
        }
        return self.rowHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerColumnCell") as! PickerColumnCell
        let row = indexPath.row - self.offsetCount
        
        if indexPath.row < self.offsetCount || row >= self.datas.count {
            cell.dateLabel.text = ""
        }else{
            cell.dateLabel.text = self.datas[row] as? String
        }
        
        if tableView == self.centerTableView {
            cell.dateLabel.textColor = UIColor.white
            cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }else{
            cell.dateLabel.textColor = UIColor(red: 212/255.0, green: 213/255.0, blue: 220/255.0, alpha: 1.0)
            cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 14.5)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.offsetCount || indexPath.row >= self.datas.count + self.offsetCount {
            return
        }
        let selectedRow = indexPath.row - self.offsetCount
        tableView.selectRow(at: IndexPath.init(row: selectedRow, section: indexPath.section), animated: true, scrollPosition: .top)
        self.delegate?.pickerView(pickerView: self, didSelectRow: selectedRow)
    }
    
    //MARK:scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if scrollView == self.centerTableView  {
            self.upTableView.contentOffset = CGPoint(x: 0, y: offset.y)
            self.downTableView.contentOffset = CGPoint(x: 0, y: offset.y)
            return;
        }
        
        if scrollView == self.downTableView {
            self.centerTableView.contentOffset = CGPoint(x: 0, y: offset.y)
            return
        }
        
        if scrollView == self.upTableView {
            self.centerTableView.contentOffset = CGPoint(x: 0, y: offset.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        setupTableViewScroll(tableView: scrollView as! UITableView, animated: true)
        let row =  self.centerTableView.contentOffset.y / self.rowHeight + 0.5
        self.delegate?.pickerView(pickerView: self, didSelectRow: Int(row))
    }
    
    //防止点击其中的cell轮转时文字不居中现象
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if !self.isSelectedRow {
            setupTableViewScroll(tableView: scrollView as! UITableView, animated: false)
        }
        if isSelectedRow {
            isSelectedRow = false
        }
    }
    
    func setupTableViewScroll(tableView:UITableView,animated:Bool){
        let offsetPoint = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + self.rowHeight / 2)
        let indexPath = tableView.indexPathForRow(at: offsetPoint)
        if indexPath != nil {
            tableView.scrollToRow(at: indexPath!, at: .top, animated: animated)
        }
    }
}
