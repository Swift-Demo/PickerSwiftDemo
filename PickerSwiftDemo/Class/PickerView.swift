//
//  PickerView.swift
//  PickerSwiftDemo
//
//  Created by os on 2019/11/27.
//  Copyright © 2019 os. All rights reserved.
//

import UIKit

protocol PickerViewDataSource : NSObjectProtocol {
//    func numberOfComponents(in pickerView: PickerView) -> Int
    func pickerView(_ pickerView: PickerView, numberOfRowsInComponent component: Int) -> Int
}

@objc protocol PickerViewDelegate : NSObjectProtocol {
    @objc optional func pickerView(_ pickerView: PickerView, rowHeightForComponent component: Int) -> CGFloat
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, forComponent component: Int) -> String?
    func pickerView(_ pickerView:PickerView,didSelectRow row:Int,forComponent component: Int)
}

class PickerView: UIView {

    weak open var dataSource: PickerViewDataSource?
    weak open var delegate: PickerViewDelegate?
    
    var rowHeight:CGFloat = 0
    var isSelected:Bool = false
    var isSubViewLayouted:Bool = false
    
    private var numberOfComponents:Int = 2
    private var columnViewList = [PickerColumnView]()
    private var selectedComponentList:NSMutableArray = []
    private var selectedRowList:NSMutableArray = []
    private var selectedAnimationList:NSMutableArray = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isSubViewLayouted {
            return
        }
        isSubViewLayouted = true
        setupColumnView()
        
        if isSelected {
            selectedRowList.enumerateObjects { (obj, idx, stop) in
                let componentIdx = selectedComponentList[idx] as? Int ?? 0
                let animation = selectedAnimationList[idx] as? Bool ?? false
                selectRow(row: obj as? Int ?? 0, inComponent: componentIdx, animated: animation)
            }
        }
    }
    //MARK:加载PickerColumnView
    func setupColumnView(){
        var columnViewList = [PickerColumnView]()
        for idx in 0..<numberOfComponents {
            let view = createColumnViewAtComponent(componentIdx: idx)
            columnViewList.append(view)
        }
        self.columnViewList = columnViewList
    }
    
    //MARK:创建PickerColumnView
    func createColumnViewAtComponent(componentIdx:Int) -> PickerColumnView{
        let width = self.frame.size.width / CGFloat(numberOfComponents)
        let row = self.dataSource?.pickerView(self, numberOfRowsInComponent: componentIdx) ?? 0
        var datas = [String]()
//        var datas = [Dictionary<String, String>]()
//        var dic = ["title":"","component":String(componentIdx)]
        var title = ""
        for idx in 0..<row {
//            dic["title"] = self.delegate?.pickerView(self, titleForRow: idx, forComponent: componentIdx) ?? "" as String
            title = self.delegate?.pickerView(self, titleForRow: idx, forComponent: componentIdx) ?? ""
            datas.append(title)
        }
        
        var columnView = columnViewInComponent(componentIdx: componentIdx)
        if columnView == nil {
            let rowHeight = rowHeightInComponent(componentIdx: componentIdx)
            columnView = PickerColumnView(frame: CGRect(x: CGFloat(componentIdx) * width, y: 0, width: width, height: self.frame.size.height), rowHeight: rowHeight, isCycleScroll: false, datas: datas as NSArray)
            columnView?.delegate = self
            self.addSubview(columnView!)
        }
        columnView?.componentIdx = componentIdx
        return columnView!
    }
    
    //MARK:获取已有PickerColumnView
    func columnViewInComponent(componentIdx:Int) -> PickerColumnView? {
        if self.columnViewList.count == 0 {
            return nil
        }
        var view:PickerColumnView?
        for obj in self.columnViewList {
            if obj.componentIdx == componentIdx {
                view = obj
                break
            }
        }
        return view
    }
    
    //MARK:获取PickerColumnView的高度
    func rowHeightInComponent(componentIdx:Int) -> CGFloat {
        let height = self.delegate?.pickerView?(self, rowHeightForComponent: componentIdx)
        
        if height != nil {
            return height!
        } else if self.rowHeight != 0 {
            return self.rowHeight
        }
        self.rowHeight = 44
        return self.rowHeight
    }
    
    func selectRow(row:Int,inComponent component:Int,animated:Bool){
        if isSubViewLayouted {
            let view = columnViewInComponent(componentIdx: component)
            view?.selectRow(row: row, animated: animated)
            return
        }
        
        if !isSubViewLayouted {
            selectedComponentList.add(component)
            selectedRowList.add(row)
            selectedAnimationList.add(animated)
        }
        
       isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PickerView:PickerColumnViewDelegate {
    
    func pickerView(pickerView: PickerColumnView, didSelectRow row: Int) {
        self.delegate?.pickerView(self, didSelectRow: row, forComponent: pickerView.componentIdx)
    }
}
