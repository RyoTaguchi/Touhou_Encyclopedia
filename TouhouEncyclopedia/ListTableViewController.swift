//
//  ListTableViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/07/09.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit
import SQLite

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    public enum ListDataType : Int {
        case LIST_DATA_INIT_VALUE   = 0
        //
        case LIST_DATA_WORKS        = 1
        case LIST_DATA_CHAR_WIN     = 2
        case LIST_DATA_CHAR_OLD     = 3
        case LIST_DATA_SPELLS       = 4
        case LIST_DATA_SKILLS       = 5
        case LIST_DATA_SHOTS        = 6
        case LIST_DATA_MUSICS       = 7
        case LIST_DATA_LANDS        = 8
        case LIST_DATA_TALKS        = 9
    }
    
    var checkValidation = FileManager.default
    
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

        //各種初期化
        initSectionList()
        initObjectList()
        
        //listTableViewにイベントのrecognaizer設定
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListTableViewController.cellLongPressed(sender:)))
        longPressRecognizer.delegate = self
        listTableView.addGestureRecognizer(longPressRecognizer)
    }
    
    //リストを初期化
    func initObjectList() {
        
        let sqlFileManager = SqlFileManager.sqlFileManager
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return
        case ListDataType.LIST_DATA_CHAR_WIN:
            objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_DETAILPAGE", sortKey: "IS_DETAILPAGE")
            return
        case ListDataType.LIST_DATA_CHAR_OLD:
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
    
    //セクションリストを初期化
    func initSectionList(){
        switch dataType {
        case ListDataType.LIST_DATA_CHAR_WIN:
            sectionList = ["紅"," ","妖"," ","萃"," ","永"," ","花"," ","風"," ","緋"," ","地"," ","星"," ","非"," ","ダ"," ","神"," ","心"," ","輝"," ","深"," ","紺"," ","天"," ","他"]
            sectionNumList = [1, 12, 23, 24, 32, 37, 45, 47, 55, 63, 64, 65, 72, 73, 81, 82, 89, 92, objectList.count]
        default:
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = barTitle
    }
    
    //セクション数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return 1
        default:
            return 1
        }
    }
    
    //セクションのセル数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return 1
        default:
            if section == 0 {
                return objectList.count
            } else {
                return 0
            }
        }
    }
    
    //セクション名の配列を返す。セクションの名前と、各セクションの要素数を設定
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionList
    }
    
    //セクションにジャンプする際に呼ばれる
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        var cellNum:Int = 0
        
        switch dataType {
        case ListDataType.LIST_DATA_CHAR_WIN:
            cellNum = sectionNumList[index/2]
            let indexPath:IndexPath = IndexPath(row: cellNum-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
        default:
            cellNum = 0
        }
        
        return cellNum
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
        let allIndex:Int = convertIndexpathToTatalIndex(indexPath: indexPath)
        
        //テキスト設定
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = getCellText(index: allIndex)
        }
        
        //画像設定
        if isWithImage() {
            if let imageView = cell.viewWithTag(2) as? UIImageView {
                let imagePath:String = getCellImagePath(index: allIndex)
                if checkValidation.fileExists(atPath: imagePath) {
                    imageView.image = UIImage(contentsOfFile: imagePath)
                } else {
                    print("ImageFile(" + imagePath + ") does not exist.")
                }
            }
        }
        
        //インディケータ表示
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    //画像ありか無しかを判定
    func isWithImage() -> Bool {
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return true
        case ListDataType.LIST_DATA_CHAR_WIN:
            return true
        case ListDataType.LIST_DATA_CHAR_OLD:
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
    
    //インデックスのパスを全体でのものに変換
    func convertIndexpathToTatalIndex(indexPath: IndexPath) -> Int {
     
        if (sectionList.count <= 1) {
            return indexPath.row
        } else {
            var totalIndex:Int = indexPath.row
            for i:Int in 0..<indexPath.section {
                if (i != indexPath.section+1){
                    totalIndex += sectionNumList[(indexPath.section/2)+1] - sectionNumList[indexPath.section/2]
                }
            }
            
            if totalIndex > 90 {
                print("")
            }
            return totalIndex
        }
    }
    
    
    //セルのテキスト取得
    func getCellText(index: Int) -> String {
        
        var cellText:String = ""
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return cellText
        case ListDataType.LIST_DATA_CHAR_WIN:
            cellText = objectList[index][Expression<String>("NAME")]
        case ListDataType.LIST_DATA_CHAR_OLD:
            return cellText
        case ListDataType.LIST_DATA_SPELLS:
            return cellText
        case ListDataType.LIST_DATA_SKILLS:
            return cellText
        case ListDataType.LIST_DATA_SHOTS:
            return cellText
        case ListDataType.LIST_DATA_MUSICS:
            return cellText
        case ListDataType.LIST_DATA_LANDS:
            return cellText
        case ListDataType.LIST_DATA_TALKS:
            return cellText
        default:
            return cellText
        }
        
        return cellText
    }
    
    
    //セル画像のパス取得
    func getCellImagePath(index: Int) -> String {
        
        var imagePath:String = ""
        
        switch dataType {
        case ListDataType.LIST_DATA_WORKS:
            return imagePath
        case ListDataType.LIST_DATA_CHAR_WIN:
            let fileName:String = "charLogo/" + objectList[index][Expression<String>("LOGOFILENAME")]
            imagePath = Bundle.main.path(forResource:fileName , ofType: "png")!
        case ListDataType.LIST_DATA_CHAR_OLD:
            return imagePath
        case ListDataType.LIST_DATA_SPELLS:
            return imagePath
        case ListDataType.LIST_DATA_SKILLS:
            return imagePath
        case ListDataType.LIST_DATA_SHOTS:
            return imagePath
        case ListDataType.LIST_DATA_MUSICS:
            return imagePath
        case ListDataType.LIST_DATA_LANDS:
            return imagePath
        case ListDataType.LIST_DATA_TALKS:
            return imagePath
        default:
            return imagePath
        }
        
        return imagePath
    }
    
    
    //セル長押し時の処理
    func cellLongPressed(sender : UILongPressGestureRecognizer){
        //押された位置でcellのpathを取得
        let point = sender.location(in: listTableView)
        let indexPath = listTableView.indexPathForRow(at: point)
        
        //長押しの開始時は何もしない
        if sender.state == UIGestureRecognizerState.began{
            return
        }
        
        showAlert(indexPath: indexPath!)
    }
    
    
    //アクションアラート生成
    func showAlert(indexPath: IndexPath){
        
    }
}
