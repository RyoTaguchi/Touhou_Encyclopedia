//
//  ListTableViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/07/09.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit
import SQLite

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public enum ListDataType : Int {
        case LIST_DATA_INIT_VALUE   = 0
        //
        case LIST_DATA_WORKS        = 1
        case LIST_DATA_CHARACTERS   = 2
        case LIST_DATA_SPELLS       = 3
        case LIST_DATA_SKILLS       = 4
        case LIST_DATA_SHOTS        = 5
        case LIST_DATA_MUSICS       = 6
        case LIST_DATA_LANDS        = 7
        case LIST_DATA_TALKS        = 8
    }
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    var barTitle:String = ""
    
    var dataType:ListDataType = ListDataType.LIST_DATA_INIT_VALUE
    
    var sectionList:Array<String> = []
    var sectionNumList:Array<Int> = []
    
    // 表示するオブジェクトを一括で持つ配列
    var objectList:Array<SQLite.Row> = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        listTableView.delegate = self
        listTableView.dataSource = self

        
        
        
        InitObjectList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = barTitle
    }
    
    //セクションのセル数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    //セルの内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得
        let cell:UITableViewCell
        if isWithImage() {
            cell = listTableView.dequeueReusableCell(withIdentifier: "cellWithImage", for: indexPath) as UITableViewCell
        } else {
            cell = listTableView.dequeueReusableCell(withIdentifier: "cellNoImage", for: indexPath) as UITableViewCell
        }
        
        //インデックス取得
        let allIndex:Int = ConvertIndexpathToTatalIndex(indexPath: indexPath)
        
        //テキスト設定
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = objectList[allIndex][Expression<String>("NAME")]
        }
        
        //画像設定
        if isWithImage() {
            if let imageView = cell.viewWithTag(2) as? UIImageView {
                imageView.image = UIImage(named: "Icon/charWinIcon.jpg")
            }
        }
        
        
        
        return cell
    }
    
    //セクションの各要素をセット
    func SetSectionInfo() {
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return
        case ListDataType.LIST_DATA_CHARACTERS:
            
            //sqlFileManager.
            return
        case ListDataType.LIST_DATA_SPELLS:
            return
        case ListDataType.LIST_DATA_SKILLS:
            return
        case ListDataType.LIST_DATA_SHOTS:
            return
        case ListDataType.LIST_DATA_MUSICS:
            return
        case ListDataType.LIST_DATA_LANDS:
            return
        case ListDataType.LIST_DATA_TALKS:
            return
        default:
            return
        }
    }
    
    //リストを初期化
    func InitObjectList() {
        
        let sqlFileManager = SqlFileManager.sqlFileManager
        
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return
        case ListDataType.LIST_DATA_CHARACTERS:
            objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_DETAILPAGE", sortKey: "IS_DETAILPAGE")
            return
        case ListDataType.LIST_DATA_SPELLS:
            return
        case ListDataType.LIST_DATA_SKILLS:
            return
        case ListDataType.LIST_DATA_SHOTS:
            return
        case ListDataType.LIST_DATA_MUSICS:
            return
        case ListDataType.LIST_DATA_LANDS:
            return
        case ListDataType.LIST_DATA_TALKS:
            return
        default:
            return
        }
    }
    
    //インデックスのパスを全体でのものに変換
    func ConvertIndexpathToTatalIndex(indexPath: IndexPath) -> Int {
     
        if (sectionList.count == 0) {
            return indexPath.row
        } else {
            var totalIndex:Int = 0
            for i:Int in 0..<indexPath.section {
                if (i != indexPath.section+1){
                    totalIndex += sectionNumList[i]
                } else {
                    totalIndex += indexPath.row
                }
            }
            
            return totalIndex
        }
    }
    
    //画像ありか無しかを判定
    func isWithImage() -> Bool {
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return true
        case ListDataType.LIST_DATA_CHARACTERS:
            return true
        case ListDataType.LIST_DATA_SPELLS:
            return true
        case ListDataType.LIST_DATA_SKILLS:
            return true
        case ListDataType.LIST_DATA_SHOTS:
            return true
        case ListDataType.LIST_DATA_MUSICS:
            return true
        case ListDataType.LIST_DATA_LANDS:
            return false
        case ListDataType.LIST_DATA_TALKS:
            return false
        default:
            return false
        }
    }
}
