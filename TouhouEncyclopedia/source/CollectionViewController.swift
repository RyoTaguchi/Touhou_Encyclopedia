//
//  CollectionViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/08/19.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit
import SQLite

class CollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "cell"
    
    public enum CollectionDataType: Int {
        case COLLECTION_DATA_INIT_VALUE   = 0
        //
        case COLLECTION_DATA_SPELL        = 1
        case COLLECTION_DATA_SKILL        = 2
        case COLLECTION_DATA_SHOT         = 3
        case COLLECTION_DATA_MUSIC_ZUN    = 4
        case COLLECTION_DATA_MUSIC_NO_ZUN = 5
        case COLLECTION_DATA_TALKS        = 6
    }
    
    public enum CollectionDisplayType: Int {
        case DISPLAY_INIT_VALUE     = 0
        //
        case DISPLAY_BY_TITLE       = 1
        case DISPLAY_BY_CHARACTER   = 2
    }
    
    var m_dataType:CollectionDataType = CollectionDataType.COLLECTION_DATA_INIT_VALUE
    var m_displayType:CollectionDisplayType = CollectionDisplayType.DISPLAY_INIT_VALUE
    var m_batTitle = ""
    
    private var checkValidation = FileManager.default
    
    private var objectList:Array<SQLite.Row> = []               //表示するオブジェクトを一括で持つ配列
    
    private var objectList_Music:Array<Array<SQLite.Row>> = []  //表示するオブジェクトを一括で持つ配列（楽曲用）
    private let sectionNumOfZunMusic   = 3
    private let sectionNumOfNoZunMusic = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //メンバ変数初期化
        //会話集のときはTabでないので例外処理
        if m_dataType != CollectionDataType.COLLECTION_DATA_TALKS {
            
            let tabBarController:TabBarController = self.tabBarController as! TabBarController
            let tabIndex:Int = tabBarController.m_displayTabIndex
            
            m_dataType = CollectionViewController.CollectionDataType(rawValue: tabBarController.m_mode.rawValue)!
            
            if tabIndex == 1 {
                m_displayType = CollectionDisplayType.DISPLAY_BY_TITLE
            } else if tabIndex == 2 {
                m_displayType = CollectionDisplayType.DISPLAY_BY_CHARACTER
            }
            
            //タブバーにセルが隠れる問題の修正
            self.tabBarController?.tabBar.isTranslucent = false
            
            //自作インデックスタイトルを設定
            if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER {
                if (m_dataType == CollectionDataType.COLLECTION_DATA_SPELL) || (m_dataType == CollectionDataType.COLLECTION_DATA_SKILL) || (m_dataType == CollectionDataType.COLLECTION_DATA_SHOT) {
                    let screenWidth = UIScreen.main.bounds.size.width
                    let screenHeight = UIScreen.main.bounds.size.height
                    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
                    let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
                    let tabBarHieght = self.tabBarController?.tabBar.frame.size.height
                    
                    var indexTitles:Array<String> = []
                    var indexNumbers:Array<Int> = []
                    switch m_dataType {
                    case CollectionDataType.COLLECTION_DATA_SPELL:
                        indexTitles =  ["紅","妖","萃","永","花","風","緋","地","星","非","ダ","大","神","心","輝","深","紺","天"]
                        indexNumbers = [1, 10, 22, 23, 31, 36, 44, 46, 54, 61, 62, 63, 67, 74, 75, 84, 86, 93]
                    case CollectionDataType.COLLECTION_DATA_SKILL:
                        indexTitles = ["紅","妖","萃","永","花","風","緋","地","星","神","心","輝","深"]
                        indexNumbers = [1, 8, 12, 13, 15, 17, 20, 22, 24, 26, 29, 30, 31]
                    case CollectionDataType.COLLECTION_DATA_SHOT:
                        indexTitles = ["紅","妖","萃","永","花","風"]
                        indexNumbers = [1, 7, 14, 15, 18, 23]
                    default:
                        break;
                    }
                    
                    let indexTileBar:CollectionIndexTitle = CollectionIndexTitle(frame: CGRect(x: screenWidth - 15, y: 0, width: 15, height: screenHeight - statusBarHeight - navigationBarHeight! - tabBarHieght!), indexTitles: indexTitles, indexNumbers: indexNumbers)
                    let panGesture = EextendPanGestureRecognizer.init(target: self, action: #selector(self.panIndexTitleView(sender:)))
                    indexTileBar.addGestureRecognizer(panGesture)
                    
                    self.view.addSubview(indexTileBar)
                    
                    if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 5 + 15)
                    }
                    collectionView?.showsVerticalScrollIndicator = false
                    
                }
            }
        }
        
        initObjectList()
    }

    //リストを初期化
    func initObjectList() {
        
        let sqlFileManager = SqlFileManager.sqlFileManager
        
        switch m_dataType {
            
        case CollectionDataType.COLLECTION_DATA_SPELL:
            if m_displayType == CollectionDisplayType.DISPLAY_BY_TITLE {
                objectList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "GAME", key: "IS_SPELL", sortKey: "IS_SPELL")
            } else if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER {
                objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_SPELL", sortKey: "IS_SPELL")
            }
            return
            
        case CollectionDataType.COLLECTION_DATA_SKILL:
            if m_displayType == CollectionDisplayType.DISPLAY_BY_TITLE {
                objectList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "GAME", key: "IS_SKILL", sortKey: "IS_SKILL")
            } else if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER {
                objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_SKILL", sortKey: "IS_SKILL")
            }
            return
            
        case CollectionDataType.COLLECTION_DATA_SHOT:
            if m_displayType == CollectionDisplayType.DISPLAY_BY_TITLE {
                objectList = sqlFileManager.getRecordArray(sql: "titleDetailData", table: "GAME", key: "IS_SHOT", sortKey: "IS_SHOT")
            } else if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER {
                objectList = sqlFileManager.getRecordArray(sql: "charDetailData", table: "WIN", key: "IS_SHOT", sortKey: "IS_SHOT")
            }
            return
            
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            objectList_Music.append( sqlFileManager.getRecordArray(sql: "titleDetailData", table: "GAME", key: "MUSIC", sortKey: "ID") )
            objectList_Music.append( sqlFileManager.getRecordArray(sql: "titleDetailData", table: "CD", key: "MUSIC", sortKey: "ID") )
            return
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return
        case CollectionDataType.COLLECTION_DATA_TALKS:
            objectList = sqlFileManager.getRecordArray(sql: "talkData", table: "TH_DATA", key: "TH_ID", sortKey: "TH_ID")
            return
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        switch m_dataType {
        case CollectionDataType.COLLECTION_DATA_SPELL, CollectionDataType.COLLECTION_DATA_SKILL, CollectionDataType.COLLECTION_DATA_SHOT, CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            let tabBarController:TabBarController = self.tabBarController as! TabBarController
            self.tabBarController?.title = tabBarController.m_barTitle
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
        default:
            self.navigationItem.title = m_batTitle
        }
    }
    
    
    //セクション数を返す
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch m_dataType {
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            return sectionNumOfZunMusic
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return 2
        default:
            return 1
        }
    }


    //セクション内のセル数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch m_dataType {
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            if section != (sectionNumOfZunMusic - 1) {
                return objectList_Music[section].count
            } else {
                return 4
            }
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return 1
        default:
            return objectList.count
        }
    }

    
    //セルの内容を設定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        //テキスト設定
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = getCellText(indexPath: indexPath)
            textLabel.adjustsFontSizeToFitWidth = true
        }
        
        //画像設定
        if let imageView = cell.viewWithTag(2) as? UIImageView {
            let imagePath:String = getCellImagePath(indexPath: indexPath)
            if checkValidation.fileExists(atPath: imagePath) {
                imageView.image = UIImage(contentsOfFile: imagePath)
            } else {
                print("ImageFile(" + imagePath + ") does not exist.")
            }
        }
    
        return cell
    }
    
    
    //セルのテキスト取得
    func getCellText(indexPath: IndexPath) -> String {
        
        switch m_dataType {
            
        case CollectionDataType.COLLECTION_DATA_SPELL, CollectionDataType.COLLECTION_DATA_SKILL, CollectionDataType.COLLECTION_DATA_SHOT:
            
            let title:String?
            if m_displayType == CollectionDisplayType.DISPLAY_BY_TITLE {
                title = objectList[indexPath.row][Expression<String?>("TITLE")]
            } else if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER{
                title = objectList[indexPath.row][Expression<String?>("NAME_SHORT")]
            } else {
                title = nil
            }
            if title != nil {
                return title!
            } else {
                return ""
            }
            
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            if indexPath.section != (sectionNumOfZunMusic - 1) {
                return objectList_Music[indexPath.section][indexPath.row][Expression<String>("TITLE")]
            } else {
                let tmpArray = ["書籍付属CD", "稀翁玉", "秋霜玉", "その他"]
                return tmpArray[indexPath.row]
            }
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return ""
            
        case CollectionDataType.COLLECTION_DATA_TALKS:
            let sqlFileManager = SqlFileManager.sqlFileManager
            let th_ID:Int = objectList[indexPath.row][Expression<Int>("TH_ID")]
            if let row = sqlFileManager.getOneRecord(sql: "titleDetailData", table: "GAME", key: "ID", filter: String(th_ID)) {
                return row[Expression<String>("TITLE")]
            } else {
                return ""
            }
            
        default:
            return ""
        }
    }

    
    //セル画像のパス取得
    func getCellImagePath(indexPath: IndexPath) -> String {
        
        var imagePath:String = ""
        
        switch m_dataType {
            
        case CollectionDataType.COLLECTION_DATA_SPELL, CollectionDataType.COLLECTION_DATA_SKILL, CollectionDataType.COLLECTION_DATA_SHOT:

            var fileName:String
            if m_displayType == CollectionDisplayType.DISPLAY_BY_TITLE {
                fileName = "titleImgFile/titleImgFile_" + "\(objectList[indexPath.row][Expression<Int>("ID")])"
                imagePath = Bundle.main.path(forResource:fileName , ofType: "jpg")!
            } else if m_displayType == CollectionDisplayType.DISPLAY_BY_CHARACTER{
                fileName = "charLogoImgFile/" + objectList[indexPath.row][Expression<String>("LOGOFILENAME")]
                imagePath = Bundle.main.path(forResource:fileName , ofType: "png")!
            }
            
            return imagePath
        
        case CollectionDataType.COLLECTION_DATA_TALKS:
            let fileName:String = "titleImgFile/titleImgFile_" + "\(objectList[indexPath.row][Expression<Int>("TH_ID")])"
            imagePath = Bundle.main.path(forResource:fileName , ofType: "jpg")!
            return imagePath
         
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            var fileName:String
            switch indexPath.section {
            case 0:
                let id:Int? = Int(objectList_Music[indexPath.section][indexPath.row][Expression<Int64?>("ID")]!)
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
            
        default:
            return imagePath
        }
    }
    

    // Segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @objc private func panIndexTitleView(sender: EextendPanGestureRecognizer) {
        
        let location:CGPoint = sender.location(in: sender.view)
        let indexTileView = sender.view as! CollectionIndexTitle
        let row:Int = indexTileView.getLabelIndex(location: location)
        
        collectionView?.scrollToItem(at: IndexPath.init(row: row, section: 0), at: .top, animated: false)
    }
}
