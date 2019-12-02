//
//  ViewController.swift
//  PickerSwiftDemo
//
//  Created by os on 2019/11/27.
//  Copyright © 2019 os. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var datas1:NSArray = []
    var datas2:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datas1 = ["2009年", "2010年", "2011年", "2012年", "2013年", "2014年", "2015年", "2016年", "2017年", "2018年","2019年"]
        self.datas2=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        let pickerView = PickerView(frame: CGRect(x: 10, y: 50, width: 281, height: 195))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.rowHeight = 39
        pickerView.backgroundColor = UIColor(red: 61/255.0, green: 66/255.0, blue: 109/255.0, alpha: 1.0)
        self.view.addSubview(pickerView)
        let idx = datas1.count - 1
        print("idx:",idx)
        pickerView.selectRow(row: idx, inComponent: 0, animated: false)
        pickerView.selectRow(row: 3, inComponent: 1, animated: false)
    }


}

extension ViewController:PickerViewDelegate,PickerViewDataSource {
    
    func pickerView(_ pickerView: PickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.datas1.count
        }
        return self.datas2.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.datas1[row] as? String
        }
        return self.datas2[row] as? String
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, forComponent component: Int) {
        print("选中的列：",component,"选中的行：",row)
        if component == 1 {
            print("选中的行数据：",datas2[row])
            if row > 10 {
                pickerView.selectRow(row: 10, inComponent: 1, animated: true)
            }
        }
    }
    
}
