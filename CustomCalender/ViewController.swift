//
//  ViewController.swift
//  CustomCalender
//
//  Created by Yen Hung Cheng on 2023/3/16.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var now = Date()
    let dateformatter = DateFormatter()
    var totalSquares = [String]()
    var allButton = [UIButton]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCellsView()
        setMonthView()
        
        
    }
    
    func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 10

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    
    func setMonthView() {
        totalSquares.removeAll()

        let daysInMonth = CalendarHelper().daysInMonth(date: now)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: now)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)

        var count: Int = 1

        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                totalSquares.append("")
            }
            else
            {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        let text = CalendarHelper().monthString(date: now)
        + " " + CalendarHelper().yearString(date: now)
                
        monthLabel.text = text
    }
    
    
    
    
    @IBAction func nextMonth(_ sender: UIButton) {
        now = CalendarHelper().plusMonth(date: now)
        setMonthView()
        closealltoggle(allButton)
        collectionView.reloadData()

    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        now = CalendarHelper().minusMonth(date: now)
        setMonthView()
        closealltoggle(allButton)
        collectionView.reloadData()

    }
    
    // 預設所有 button 都未選取
    func closealltoggle(_ button: [UIButton]) {
        for i in button {
            i.isSelected = false
        }
    }
    
    
    @objc func touchButton(sender: UIButton) {
        // 關閉所有 Button 選取
        closealltoggle(allButton)
        // 判斷是否為空的 Button
        if sender.titleLabel?.text == "Button" {
            sender.isSelected = false
            sender.isEnabled = false
        }else {
            sender.isSelected.toggle()
            // 取得點選日期
            print("\(CalendarHelper().yearandmonth(date: now))/\(sender.titleLabel?.text! ?? "")")
        }
        
        // 取得點選日期
        var selectDay = "\(CalendarHelper().yearandmonth(date: now))/\(sender.titleLabel?.text! ?? "")"
        
        // 判斷日期數字是否小於 10，若小於 10 必須補 0
        if Int(sender.titleLabel?.text ?? "") ?? 0 < 10 {
            selectDay = "\(CalendarHelper().yearandmonth(date: now))/0\(sender.titleLabel?.text! ?? "")"
        }
        
        // 將 now 日期改為 所選的日期
        dateformatter.dateFormat = "yyyy/MM/dd"
        now = dateformatter.date(from: selectDay)!

    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalenderCollectionViewCell
        cell.dayOfMonth.setTitle(totalSquares[indexPath.item], for: .normal)
        
        
        
        // 判斷 button 上面的字是否為空白
        // 若為空白就無法點選
        if totalSquares[indexPath.item] == "" {
            cell.dayOfMonth.isEnabled = false
        }else {
            cell.dayOfMonth.isEnabled = true
        }
        
        
        // 判斷是否為今日日期
        // 若為今日日期 button 為選取模式
        dateformatter.dateFormat = "dd"
        // 若小於 10 必須補 0
        if Int(totalSquares[indexPath.item]) ?? 0 < 10 {
            if "0\(totalSquares[indexPath.item])" == dateformatter.string(from: now) {
                cell.dayOfMonth.isSelected = true
            }
        }else if totalSquares[indexPath.item] == dateformatter.string(from: now) {
            cell.dayOfMonth.isSelected = true
        }
        
        cell.dayOfMonth.addTarget(self, action: #selector(touchButton(sender: )), for: .touchUpInside)
        allButton.append(cell.dayOfMonth)

        
        return cell
    }
    
}

