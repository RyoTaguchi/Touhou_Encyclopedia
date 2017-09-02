//
//  CollectionIndexTitle.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/08/28.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class CollectionIndexTitle: UIControl {
    
    private var currentIndex:Int = 0
    private var indexTitles:Array<String>  = []
    private var indexLabels:Array<UILabel> = []
    private var indexLabelsCoordinate:Array<CGFloat> = []
    private var indexNumbers:Array<Int> = []
    
    //イニシャライザ
    init(frame: CGRect, indexTitles _indexTitles:Array<String>, indexNumbers _indexNumbers:Array<Int>) {
        super.init(frame: frame)
        
        currentIndex = 0
        indexTitles = _indexTitles
        indexNumbers = _indexNumbers
        
        setIndexTitles(_indexTitles: indexTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setIndexTitles(_indexTitles:Array<String>) {
        
        for label in indexLabels {
            label.removeFromSuperview()
        }
        
        buildIndexLabels()
    }
    
    func currentIndexTitle() -> String {
        return indexTitles[currentIndex];
    }
    
    func getLabelIndex(location:CGPoint) -> Int {
        
        for i in 0..<indexLabelsCoordinate.count {
            if location.y <= indexLabelsCoordinate[i] {
                return indexNumbers[i]
            }
        }
        
        return indexNumbers[indexLabelsCoordinate.count - 1]
    }
    
    private func buildIndexLabels() {
        
        let labelHeight:CGFloat = 10.0
        let labelWidth:CGFloat  = 15.0
        let space:CGFloat = 15
        let topY:CGFloat = (self.frame.height / 2) - ((CGFloat(indexTitles.count) * labelHeight + CGFloat(indexTitles.count - 1) * space) / 2)
        
        for i in 0..<indexTitles.count {
            let title = indexTitles[i]
            let label = UILabel(frame: CGRect(x: 0, y: topY + ((space + labelHeight) * CGFloat(i)), width: labelWidth, height: labelHeight))
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = title
            label.textColor = UIColor.blue
            label.tag = i
            indexLabels.append(label)
            self.addSubview(label)
            
            indexLabelsCoordinate.append(label.frame.origin.y + labelHeight + (space / 2) )
        }
    }
    
}
