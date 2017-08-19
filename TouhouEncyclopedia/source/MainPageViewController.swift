//
//  MainPageViewController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/07/07.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let m_iconNum:Int = 9
    private var m_selectedIcon = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let backButtonItem = UIBarButtonItem(title:"", style: .plain, target: nil, action: nil)
        self.tabBarController?.navigationItem.backBarButtonItem = backButtonItem
        
        //遷移時に暗くなる問題の修正
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
        
        setQuestionButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "東方Project大百科"
        setQuestionButton()
    }
    
    //ナビゲーションバーにボタンを設定
    func setQuestionButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        let questionBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "barIconImgFile/question.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(segueInformationPage))
        
        self.tabBarController?.navigationItem.rightBarButtonItem = questionBtn
    }
    
    //Informationページに遷移
    func segueInformationPage(sender: UIButton) {
        //遷移先のview取得
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "TextView") as! TextViewController
        nextView.barTitle = "Q & A"
        nextView.isQA = true
        
        //navigationコントローラー、アニメーションの設定
        let navi = UINavigationController(rootViewController: nextView)
        navi.modalTransitionStyle = .coverVertical
        present(navi, animated: true, completion: nil)
    }
    
    //セルの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return m_iconNum
    }
    
    
    //セルを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //セルを取得
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath as IndexPath) as UICollectionViewCell
        
        //set image & label
        let iconImageView = cell.viewWithTag(1) as! UIImageView
        let iconLabel = cell.viewWithTag(2) as! UILabel
        var iconImagePath:String = ""
        
        switch (indexPath.row) {
        case 0:
            iconImagePath = "mainPageIconImgFile/worksIcon.jpg"
            iconLabel.text = "作品集"
            break
        case 1:
            iconImagePath = "mainPageIconImgFile/charWinIcon.jpg"
            iconLabel.text = "キャラ集(win版)"
            break
        case 2:
            iconImagePath = "mainPageIconImgFile/charOldIcon.jpg"
            iconLabel.text = "キャラ集(旧作)"
            break
        case 3:
            iconImagePath = "mainPageIconImgFile/spellIcon.jpg"
            iconLabel.text = "スペルカード集"
            break
        case 4:
            iconImagePath = "mainPageIconImgFile/skillIcon.jpg"
            iconLabel.text = "スキル集"
            break
        case 5:
            iconImagePath = "mainPageIconImgFile/shotIcon.jpg"
            iconLabel.text = "ショット集"
            break
        case 6:
            iconImagePath = "mainPageIconImgFile/musicIcon.jpg"
            iconLabel.text = "音楽集"
            break
        case 7:
            iconImagePath = "mainPageIconImgFile/locationIcon.jpg"
            iconLabel.text = "地名集"
            break
        case 8:
            iconImagePath = "mainPageIconImgFile/talkIcon.jpg"
            iconLabel.text = "会話集"
            break
        default:
            break
        }
        
        iconImageView.image = UIImage(named: iconImagePath)
        
        return cell
    }
    
    //セルが選択された場合の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        m_selectedIcon = indexPath.row
        
        switch (m_selectedIcon) {
        case 0, 1, 2, 7:
            performSegue(withIdentifier: "SegueForTableViewFromHome",sender: nil)
        case 3, 4, 5:
            performSegue(withIdentifier: "SegueForSpellsTabController",sender: nil)
        default:
            break
        }
    }
    
    //Segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        //ListTableViewに遷移
        if (segue.identifier == "SegueForTableViewFromHome") {
            let nextView: ListTableViewController = (segue.destination as? ListTableViewController)!
            
            switch (m_selectedIcon) {
            case 0:
                nextView.m_dataType = ListTableViewController.ListDataType.LIST_DATA_WORKS
                nextView.m_barTitle = "作品集"
            case 1:
                nextView.m_dataType = ListTableViewController.ListDataType.LIST_DATA_CHAR_WIN
                nextView.m_barTitle = "キャラクター集（Win版）"
            case 2:
                nextView.m_dataType = ListTableViewController.ListDataType.LIST_DATA_CHAR_OLD
                nextView.m_barTitle = "キャラクター集（旧作）"
            case 7:
                nextView.m_dataType = ListTableViewController.ListDataType.LIST_DATA_LANDS
                nextView.m_barTitle = "地名集"
            default:
                break
            }
        }
        
        //CollectionViewに遷移
        if (segue.identifier == "SegueForSpellsTabController") {
            let nextView:TabBarController = (segue.destination as? TabBarController)!
            
            switch (m_selectedIcon) {
            case 3:
                nextView.m_mode = TabBarController.TabMode.MODE_SPELL
            case 4:
                nextView.m_mode = TabBarController.TabMode.MODE_SKILL
            case 5:
                nextView.m_mode = TabBarController.TabMode.MODE_SHOT
            default:
                break
            }
        }
    }
}
