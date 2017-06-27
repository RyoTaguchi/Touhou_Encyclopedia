//
//  PlistFileManager.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/06/26.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//
//  Plistファイルの管理クラス

import UIKit

class PlistFileManager
{
    private var plistFilePath:String
    private let plistKeyList:[String] = ["bootTab", "sortOrder", "textSize", "appearanceTilteDetail", "showSpellPronunciation", "sortByPronunciationOption", "customTitleImage", "SQLUpdate", "openCell", "rotationImage", "showEnglishMode",]
    private let plistValueList:[NSNumber] = [0, 0, 2, 0, 1, 0, 0, 0, 0, 0, 0]
    
    private init()
    {
        //initialize
        let documentDirPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        plistFilePath = documentDirPath.appending("/Setting.plist");
        
        //plistファイルがなければ作成
        if !(FileManager.default.fileExists(atPath:plistFilePath)) {
            MakePlistFile()
        }
    }
    
    //plistファイル作成
    private func MakePlistFile()
    {
        //plist用ディクショナリ
        var settingDic : Dictionary<String, NSNumber> = [:]
        
        //各値を格納
        for i in 0...(plistKeyList.count-1) {
            settingDic[plistKeyList[i]] = plistValueList[i]
        }
        let nsdictionary = settingDic as NSDictionary
        
        if nsdictionary.write(toFile:plistFilePath, atomically: true) {
            print("Successed to write plist.")
        } else {
            print("Failed to write plist.")
        }
    }
    
    //plistファイル更新
    func UpdatePlistFile()
    {
        //plist用ディクショナリ
        var plistDic = NSDictionary(contentsOfFile:plistFilePath) as? Dictionary<String, NSNumber>
        
        //各値を更新
        for i in 0..<(plistKeyList.count) {
            if let _:NSNumber = plistDic?[plistKeyList[i]] {
                //plistDic?[plistKeyList[i]] = plistValueList[i]
            } else {
                plistDic?[plistKeyList[i]] = plistValueList[i]
            }
        }
        
        let nsdictionary = plistDic! as NSDictionary
        if nsdictionary.write(toFile:plistFilePath, atomically: true) {
            print("Successed to write plist.")
        } else {
            print("Failed to write plist.")
        }
    }
    
    //plist値変更
    func ChangePlistValue()
    {
        
    }
    
    
    //シングルトン
    static let plistFileManager = PlistFileManager()
}
