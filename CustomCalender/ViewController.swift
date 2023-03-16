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
        collectionView.reloadData()

    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        now = CalendarHelper().minusMonth(date: now)
        setMonthView()
        collectionView.reloadData()

    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalenderCollectionViewCell
        cell.dayOfMonth.setTitle(totalSquares[indexPath.item], for: .normal)
                
        return cell
    }
    
}

