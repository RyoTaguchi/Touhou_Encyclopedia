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
    var m_barTitle:String = ""
    
    private var checkValidation = FileManager.default
    
    private var objectList:Array<SQLite.Row> = []               //表示するオブジェクトを一括で持つ配列
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //メンバ変数初期化
        let tabBarController:TabBarController = self.tabBarController as! TabBarController
        let tabIndex:Int = tabBarController.m_displayTabIndex
        
        m_barTitle = tabBarController.m_barTitle
        m_dataType = CollectionViewController.CollectionDataType(rawValue: tabBarController.m_mode.rawValue)!
        switch m_dataType {
        case CollectionDataType.COLLECTION_DATA_SPELL, CollectionDataType.COLLECTION_DATA_SKILL, CollectionDataType.COLLECTION_DATA_SHOT:
            if tabIndex == 1 {
                m_displayType = CollectionDisplayType.DISPLAY_BY_TITLE
            } else if tabIndex == 2 {
                m_displayType = CollectionDisplayType.DISPLAY_BY_CHARACTER
            }
        default:
            break
        }
        
        //タブバーにセルが隠れる問題の修正
        self.tabBarController?.tabBar.isTranslucent = false
        
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
            return
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return
        case CollectionDataType.COLLECTION_DATA_TALKS:
            return
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = m_barTitle
    }
    
    
    //セクション数を返す
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch m_dataType {
        case CollectionDataType.COLLECTION_DATA_MUSIC_ZUN:
            return 3
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
            return 1
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
            return ""
        case CollectionDataType.COLLECTION_DATA_MUSIC_NO_ZUN:
            return ""
        case CollectionDataType.COLLECTION_DATA_TALKS:
            return ""
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
            
        default:
            return imagePath
        }
    }
    

    // Segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
