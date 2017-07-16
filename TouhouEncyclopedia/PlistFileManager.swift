//
//  PlistFileManager.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/06/26.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//
//  Plistファイルの管理クラス

import UIKit

class PlistFileManager {
    
    private var plistFilePath:String
    private let plistKeyList:[String] = ["bootTab", "sortOrder", "textSize", "appearanceTilteDetail", "showSpellPronunciation", "sortByPronunciationOption", "customTitleImage", "SQLUpdate", "openCell", "rotationImage", "showEnglishMode",]
    private let plistValueList:[NSNumber] = [0, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0]
    var plistData:Dictionary<String, NSNumber>?
    
    private init(){
        //initialize
        let documentDirPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        plistFilePath = documentDirPath.appending("/Setting.plist")
        
        
        //plistファイルがなければ作成
        if !(FileManager.default.fileExists(atPath:plistFilePath)) {
            makePlistFile()
        } else {
            plistData = NSDictionary(contentsOfFile:plistFilePath) as? Dictionary<String, NSNumber>
        }
    }
    
    //plistファイル作成
    private func makePlistFile() {
        //各値を格納
        for i in 0...(plistKeyList.count-1) {
            plistData?[plistKeyList[i]] = plistValueList[i]
        }
        let nsdictionary = plistData! as NSDictionary
        
        if nsdictionary.write(toFile:plistFilePath, atomically: true) {
            print("Successed to write plist.")
        } else {
            print("Failed to write plist.")
        }
    }
    
    //plistファイル更新
    func updatePlistFile() {
        if plistData == nil {
            return
        }
        
        //各値を更新
        for i in 0..<(plistKeyList.count) {
            if let _:NSNumber = plistData?[plistKeyList[i]] {
                //plistDic?[plistKeyList[i]] = plistValueList[i]
            } else {
                plistData?[plistKeyList[i]] = plistValueList[i]
            }
        }
        
        let nsdictionary = plistData! as NSDictionary
        if nsdictionary.write(toFile:plistFilePath, atomically: true) {
            print("Successed to write plist.")
        } else {
            print("Failed to write plist.")
        }
    }
    
    //plist値変更
    func changePlistValue(key:String, value:NSNumber) -> Bool {
        if let _:NSNumber = plistData?[key] {
            plistData?[key] = value
        } else {
            return false
        }
        
        let nsdictionary = plistData! as NSDictionary
        if nsdictionary.write(toFile:plistFilePath, atomically: true) {
            print("Successed to write plist.")
        } else {
            print("Failed to write plist.")
        }
        
        return true
    }
    
    
    //シングルトン
    static let plistFileManager = PlistFileManager()
}
