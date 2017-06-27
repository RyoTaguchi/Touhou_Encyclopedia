//
//  SqlFileManager.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/06/27.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//
//  SQLの管理クラス

import UIKit

class SqlFileManager
{
    private let sqlFileList:[String] = ["charDetailData", "landData", "musicData", "musicData2", "shotDetailData", "skillDetailData", "spellDetailData", "stageDetailData", "talkData", "titleDetailData"]
    
    private init()
    {
        
    }
    
    func UpdateSQLFile()
    {
        //ドキュメントディレクトリのファイル一覧取得
        let documentDirPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var fileList:[String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentDirPath)
            } catch {
                print("Error : Cannot get file list in domumentDir.")
                return []
            }
        }
        
        //更新するファイルを削除
        for fileName:String in fileList{
            if fileName.contains(".jpg"){
                continue
            } else if fileName.contains(".plist"){
                continue
            } else {
                do {
                    try FileManager.default.removeItem(atPath: documentDirPath + "/" + fileName)
                    defer {
                        print("Successed to delete " + fileName)
                    }
                } catch {
                    print("Error : Cannot remove file in domumentDir.")
                }
            }
        }
        
        //sqlファイルをコピー
        let bundlePath:String = Bundle.main.bundlePath + "/SqlFile/"
        
        for sqlName:String in sqlFileList{
            let tmp:String = sqlName + ".sqlite"
            do {
                try FileManager.default.copyItem(atPath: bundlePath + tmp, toPath: documentDirPath + "/" + tmp)
                defer {
                    print("Successed to copy " + tmp)
                }
            } catch {
                print("Error : Cannot copy file to domumentDir.")
            }
        }
    }
    
    //シングルトン
    static let sqlFileManager = SqlFileManager()
}
