//
//  SqlFileManager.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/06/27.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//
//  SQLの管理クラス

import UIKit
import SQLite

class SqlFileManager {
    private let sqlFileList:[String] = ["charDetailData", "landData", "musicData", "musicData2", "shotDetailData", "skillDetailData", "spellDetailData", "stageDetailData", "talkData", "titleDetailData"]
    
    private init() {
    }
    
    // ファイルの更新必要ないかも？
    func updateSQLFile() {
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
        for fileName:String in fileList {
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
        
        for sqlName:String in sqlFileList {
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
    
    
    //SQL,Table,Key,Keyの条件を指定し、レコードを一つ取得
    func getOneRecord(sql: String, table: String, key: String, filter: String) -> SQLite.Row? {
        
        let path:String = Bundle.main.bundlePath + "/SqlFile/" + sql + ".sqlite"
        
        do {
            let db:SQLite.Connection = try Connection(path, readonly: true)
            
            // クエリ作成
            let searchTable:SQLite.Table = Table(table)
            let searchKey = Expression<String>(key)
            let query = searchTable.filter(searchKey == filter)
            
            do {
                if let record:SQLite.Row = try db.pluck(query){
                    return record
                } else {
                    print("ERROR: db.pluck(query) result is nil.")
                    return nil
                }
            } catch {
                print("ERROR: db.pluck(query) failed.")
                return nil
            }
        } catch {
            print("ERROR: Connection database failed.")
            return nil
        }
    }
    
    
    //SQL,Table,Key,SortKeyを指定し、Keyがnilでないレコードの集合を取得, sortKeyでソート
    func getRecordArray(sql: String, table: String, key: String, sortKey: String) -> Array<SQLite.Row> {
        
        var sqlRowArray:Array<SQLite.Row> = []
        let path:String = Bundle.main.bundlePath + "/SqlFile/" + sql + ".sqlite"
        
        do {
            let db:SQLite.Connection = try Connection(path, readonly: true)
            
            // クエリ作成
            let searchTable:SQLite.Table = Table(table)
            let strSearchKey = Expression<String>(key)
            let strSortKey = Expression<String>(sortKey)
            let query = searchTable.filter(strSearchKey != "0" && strSearchKey != "")
                                   .order(strSortKey)
            
            do {
                sqlRowArray = Array(try db.prepare(query))
            } catch {
                print("ERROR: db.pluck(query) failed.")
            }
        } catch {
            print("ERROR: Connection database failed.")
        }
        
        return sqlRowArray
    }
    
    
    //SQL,Tableを指定し、要素数を取得
    func getTableElementCount(sql: String, table: String) -> Int {
        
        let path:String = Bundle.main.bundlePath + "/SqlFile/" + sql + ".sqlite"
        
        do {
            let db:SQLite.Connection = try Connection(path, readonly: true)
            
            // クエリ作成
            let searchTable:SQLite.Table = Table(table)
            
            //検索
            do {
                let count = try db.scalar(searchTable.count)
                return count
            } catch {
                print("ERROR: Search database failed.")
                return 0
            }
        } catch {
            print("ERROR: Connection database failed.")
            return 0
        }
    }
    
    //シングルトン
    static let sqlFileManager = SqlFileManager()
}
