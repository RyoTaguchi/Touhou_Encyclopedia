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
    
    var m_dataType:ListDataType = ListDataType.LIST_DATA_INIT_VALUE
    var m_barTitle:String = ""
    
    @IBOutlet weak var listTableView: UITableView!
    
    private var checkValidation = FileManager.default
    
    
    
    private var objectList:Array<SQLite.Row> = []               //表示するオブジェクトを一括で持つ配列
    private var sectionDataList:Array<Array<SQLite.Row>> = []   //セクションごとに配列分けが必要な際に使う配列（作品集用）
    
    private var sectionNameList:Array<String> = []      //セクション名を格納する配列
    private var sectionNumList:Array<Int> = []          //各セクションの要素数を格納する配列
    
    private var isDisplayMainChar = true

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        listTableView.delegate = self
        listTableView.dataSource = self

        //各種初期化
        initsectionNameList()
        initObjectList()
        initBarRightButton()
        
        //listTableViewにイベントのrecognaizer設定
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ListTableViewController.cellLongPressed(sender:)))
        longPressRecognizer.delegate = self
        listTableView.addGestureRecognizer(longPressRecognizer)
    }
    
    //リストを初期化
    func initObjectList() {
        
        let sqlFileManager = SqlFileManager.sqlFileManager
        
        switch m_dataType {
            
        case ListDataType.LIST_DATA_WORKS:
            var tmpList:Array<SQLite.Row> = []
            tmpList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "GAME", key: "READ", sortKey: "ID")
            sectionDataList.append(tmpList)
            tmpList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "CD", key: "ID", sortKey: "ID")
            sectionDataList.append(tmpList)
            tmpList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "BOOK", key: "ID", sortKey: "ID")
            sectionDataList.append(tmpList)
            tmpList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "OTHER", key: "ID", sortKey: "ID")
            sectionDataList.append(tmpList)
            return
            
        case ListDataType.LIST_DATA_CHAR_WIN:
            if isDisplayMainChar == true {
                objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_DETAILPAGE", sortKey: "IS_DETAILPAGE")
            } else {
                objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "SUB", key: "ID", sortKey: "ID")
            }
            return
            
        case ListDataType.LIST_DATA_CHAR_OLD:
            objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "OLD", key: "ID", sortKey: "ID")
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
            objectList = sqlFileManager.getRecordArray(sql: "landData", table: "LAND", key: "ID", sortKey: "ID")
            return
        case ListDataType.LIST_DATA_TALKS:
            return
        default:
            return
        }
    }
    
    //セクションリストを初期化
    func initsectionNameList() {
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            sectionNameList = ["Game"," ","CD"," ","書籍"," ","他"]
        case ListDataType.LIST_DATA_CHAR_WIN:
            if isDisplayMainChar == true {
                sectionNameList = ["紅"," ","妖"," ","萃"," ","永"," ","花"," ","風"," ","緋"," ","地"," ","星"," ","非"," ","ダ"," ","神"," ","心"," ","輝"," ","深"," ","紺"," ","天"," ","他"]
                sectionNumList = [1, 12, 23, 24, 32, 37, 45, 47, 55, 63, 64, 65, 72, 73, 81, 82, 89, 92, objectList.count]
            }
        case ListDataType.LIST_DATA_CHAR_OLD:
            sectionNameList = ["靈"," ","封"," ","夢"," ","幻"," ","怪"]
            sectionNumList = [1, 9, 20, 29, 38, objectList.count]
        case ListDataType.LIST_DATA_LANDS:
            sectionNameList = ["幻想郷", "人間の里周辺", "霧の湖周辺", "魔法の森周辺", "妖怪の山周辺", "妖怪の山の反対側", "旧地獄", "異界", "その他"]
            sectionNumList = [2, 4, 3, 7, 8, 4, 2, 7, 4, objectList.count]
        default:
            return
        }
    }
    
    //右上のボタン設定
    func initBarRightButton() {
        
        switch m_dataType {
        case ListDataType.LIST_DATA_CHAR_WIN:
            self.navigationItem.rightBarButtonItem = nil
            let exchangeDisplayCharBtn:UIBarButtonItem = UIBarButtonItem(title: "サブ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(exchangeDisplayChar))
            self.navigationItem.rightBarButtonItem = exchangeDisplayCharBtn
        default:
            return
        }
    }
    
    //Win版キャラ集のときのみ使用
    //メインキャラとサブキャラの表示を入れ替え
    func exchangeDisplayChar() {
        
        if isDisplayMainChar == true {
            self.navigationItem.rightBarButtonItem?.title = "メイン"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "サブ"
        }
        
        isDisplayMainChar = !isDisplayMainChar
        initObjectList()
        listTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = m_barTitle
    }
    
    //セクション数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            return sectionDataList.count
        case ListDataType.LIST_DATA_LANDS:
            return sectionNameList.count
        default:
            return 1
        }
    }
    
    //セクションのセル数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            return sectionDataList[section].count
        case ListDataType.LIST_DATA_LANDS:
            return sectionNumList[section]
        default:
            if section == 0 {
                return objectList.count
            } else {
                return 0
            }
        }
    }
    
    //セクション名の配列を返す。これに有効な値を返すとインデックスタイトルが表示される
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            return sectionNameList
        case ListDataType.LIST_DATA_CHAR_WIN:
            if isDisplayMainChar == true {
                return sectionNameList
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    //インデックスタイトルをタッチし、セクションにジャンプする際に呼ばれる
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        var cellNum:Int = 0
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            cellNum = index/2
            let indexPath:IndexPath = IndexPath(row: 0, section: index/2)
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
            
        case ListDataType.LIST_DATA_CHAR_WIN, ListDataType.LIST_DATA_CHAR_OLD:
            cellNum = sectionNumList[index/2]
            let indexPath:IndexPath = IndexPath(row: cellNum-1, section: 0)
            tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
        default:
            cellNum = 0
        }
        
        return cellNum
    }
    
    // セクションヘッダ設定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if m_dataType == ListDataType.LIST_DATA_WORKS {
            let sectionHeaderNameList:Array<String> = ["ゲーム", "音楽CD", "書籍", "その他"]
            return sectionHeaderNameList[section]
        } else if m_dataType == ListDataType.LIST_DATA_LANDS {
            return sectionNameList[section]
        } else {
            return nil
        }
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
        
        //テキスト設定
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = getCellText(indexPath: indexPath)
        }
        
        //画像設定
        if isWithImage() {
            if let imageView = cell.viewWithTag(2) as? UIImageView {
                let imagePath:String = getCellImagePath(indexPath: indexPath)
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
    
    //セルの画像の有無を判定
    func isWithImage() -> Bool {
        
        switch m_dataType {
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
     
        if sectionNameList.count <= 1 {
            return indexPath.row
        }
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            return indexPath.row
        case ListDataType.LIST_DATA_CHAR_WIN, ListDataType.LIST_DATA_CHAR_OLD:
            var totalIndex:Int = indexPath.row
            for i:Int in 0..<indexPath.section {
                if (i != indexPath.section+1){
                    totalIndex += sectionNumList[i+1] - sectionNumList[i]
                }
            }
            return totalIndex
        default:
            var totalIndex:Int = indexPath.row
            for i:Int in 0..<indexPath.section {
                if (i != indexPath.section+1){
                    totalIndex += sectionNumList[i]
                }
            }
            return totalIndex
        }

    }
    
    
    //セルのテキスト取得
    func getCellText(indexPath: IndexPath) -> String {
        
        var cellText:String = ""
        
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            let tmpSQLData:SQLite.Row = sectionDataList[indexPath.section][indexPath.row]
            let title:String = tmpSQLData[Expression<String>("TITLE")]
            let subTitle:String? = tmpSQLData[Expression<String?>("SUBTITLE")]
            cellText = cellText + title
            if subTitle != nil {
                cellText = cellText + subTitle!
            }
            
        case ListDataType.LIST_DATA_CHAR_WIN, ListDataType.LIST_DATA_CHAR_OLD:
            let allIndex:Int = convertIndexpathToTatalIndex(indexPath: indexPath)
            cellText = objectList[allIndex][Expression<String>("NAME")]
            
        case ListDataType.LIST_DATA_SPELLS:
            return cellText
        case ListDataType.LIST_DATA_SKILLS:
            return cellText
        case ListDataType.LIST_DATA_SHOTS:
            return cellText
        case ListDataType.LIST_DATA_MUSICS:
            return cellText
        case ListDataType.LIST_DATA_LANDS:
            let allIndex:Int = convertIndexpathToTatalIndex(indexPath: indexPath)
            cellText = objectList[allIndex][Expression<String>("NAME")]
            return cellText
        case ListDataType.LIST_DATA_TALKS:
            return cellText
        default:
            return cellText
        }
        
        return cellText
    }
    
    
    //セル画像のパス取得
    func getCellImagePath(indexPath: IndexPath) -> String {
        
        var imagePath:String = ""
        
        switch m_dataType {
            
        case ListDataType.LIST_DATA_WORKS:
            var fileName:String
            switch indexPath.section {
            case 0:
                let id:Int? = Int(sectionDataList[indexPath.section][indexPath.row][Expression<Int64?>("ID")]!)
                if id != nil {
                    fileName = "titleImgFile/titleImgFile_" +  "\(id!)"
                } else {
                    fileName = "otherImgFile/noImage"
                }
            default:
                fileName = "otherImgFile/noImage"
            }
            imagePath = Bundle.main.path(forResource:fileName , ofType: "jpg")!
            return imagePath
            
        case ListDataType.LIST_DATA_CHAR_WIN:
            var fileName:String
            if isDisplayMainChar == true {
                fileName = "charLogoImgFile/" + objectList[convertIndexpathToTatalIndex(indexPath: indexPath)][Expression<String>("LOGOFILENAME")]
            } else {
                fileName = "charLogoImgFile/forOldChar"
            }
            imagePath = Bundle.main.path(forResource:fileName , ofType: "png")!
            return imagePath
            
        case ListDataType.LIST_DATA_CHAR_OLD:
            imagePath = Bundle.main.path(forResource:"charLogoImgFile/forOldChar" , ofType: "png")!
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
    }
    
    
    //セル長押し時の処理
    func cellLongPressed(sender : UILongPressGestureRecognizer) {
        
        //押された位置でcellのpathを取得
        let point = sender.location(in: listTableView)
        let indexPath = listTableView.indexPathForRow(at: point)
        
        //長押しの開始時にアクションシート表示
        if sender.state == UIGestureRecognizerState.began{
            showAlert(indexPath: indexPath!)
        }
    }
    
    
    //アクションアラート生成
    func showAlert(indexPath: IndexPath) {
        
        let index:Int = convertIndexpathToTatalIndex(indexPath: indexPath)
        let actionSheet = UIAlertController(title: "タイトル", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var copyNameActionTitle: String = ""
        var copyAllNameActionTitle: String = ""
 
        
        //各リスト固有のアクションタイトル
        switch m_dataType {
        case ListDataType.LIST_DATA_WORKS:
            let tmpSQLData:SQLite.Row = sectionDataList[indexPath.section][indexPath.row]
            let title:String = tmpSQLData[Expression<String>("TITLE")]
            let subTitle:String? = tmpSQLData[Expression<String?>("SUBTITLE")]
            actionSheet.title = title
            if subTitle != nil {
                actionSheet.title = actionSheet.title! + subTitle!
            }
            copyNameActionTitle = "選択した作品名をコピー"
            copyAllNameActionTitle = "セクションの全ての作品名を一括コピー"
        case ListDataType.LIST_DATA_CHAR_WIN, ListDataType.LIST_DATA_CHAR_OLD:
            actionSheet.title = objectList[index][Expression<String>("NAME")]
            copyNameActionTitle = "選択したキャラクター名をコピー"
            copyAllNameActionTitle = "全てのキャラクター名を一括コピー"
        case ListDataType.LIST_DATA_LANDS:
            actionSheet.title = objectList[index][Expression<String>("NAME")]
            copyNameActionTitle = "選択した地名をコピー"
            copyAllNameActionTitle = "全ての地名を一括コピー"
        default:
            print("アクション未定義")
        }
        
        
        //アクションを作成
        let action1 = UIAlertAction(title: copyNameActionTitle, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in
            self.copyObjectName(indexPath: indexPath, isAllCopy: false)
        })
        let action2 = UIAlertAction(title: copyAllNameActionTitle, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in
            self.copyObjectName(indexPath: indexPath, isAllCopy: true)
        })
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
        })
        
        //シートにアクションを追加
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancel)
        
        //アクションシートを表示
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func copyObjectName(indexPath: IndexPath, isAllCopy isAllcopy: Bool) {
        
        let pasteboard: UIPasteboard = UIPasteboard.general
        var copyString: String = ""
        
        if isAllcopy == true {
            if m_dataType == ListDataType.LIST_DATA_WORKS {
                for obj in sectionDataList[indexPath.section] {
                    let title:String = obj[Expression<String>("TITLE")]
                    let subTitle:String? = obj[Expression<String?>("SUBTITLE")]
                    copyString = copyString + title
                    if subTitle != nil {
                        copyString = copyString + subTitle!
                    }
                    copyString = copyString + "\n"
                }
            } else {
                for obj in objectList {
                    copyString = copyString + obj[Expression<String>("NAME")] + "\n"
                }
            }
            copyString = copyString.substring(to: copyString.index(before: copyString.endIndex))
        } else {
            copyString = objectList[convertIndexpathToTatalIndex(indexPath: indexPath)][Expression<String>("NAME")]
        }
        
        pasteboard.setValue(copyString, forPasteboardType: "public.text")
    }
    
}
