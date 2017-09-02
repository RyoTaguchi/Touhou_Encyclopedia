//
//  SearchPageController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/08/21.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class SearchPageController: UIViewController, UITextFieldDelegate {

    public enum SearchDataType: Int {
        case SEARCH_DATA_INIT_VALUE   = 0
        //
        case SEARCH_DATA_SPELL        = 1
        case SEARCH_DATA_SKILL        = 2
        case SEARCH_DATA_SHOT         = 3
        case SEARCH_DATA_MUSIC_ZUN    = 4
        case SEARCH_DATA_MUSIC_NO_ZUN = 5
    }
    
    private enum ButtonTag: Int {
        case CHANGE_USER_BUTTON         = 100
        case CHANGE_TITLE_BUTTON        = 101
        case CHANGE_SORT_ORDER_BUTTON   = 102
        case SEARCH_BUTTON              = 103
    }
    
    private enum SearchMode: Int {
        case SEARCH_BY_WORD = 1
        case SEARCH_BY_READ = 2
    }
    
    private var m_searchMode:SearchMode = SearchMode.SEARCH_BY_WORD
    var m_dataType:SearchDataType = SearchDataType.SEARCH_DATA_INIT_VALUE
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //メンバ変数初期化
        let tabBarController:TabBarController = self.tabBarController as! TabBarController
        m_dataType = SearchPageController.SearchDataType(rawValue: tabBarController.m_mode.rawValue)!
        
        //各種オブジェクト配置
        setUIObject()
    }
    
    //ナビゲーションバーにボタンを設定
    func setChangeSearchModeButton() {
        
        var btnStr:String = ""
        switch m_searchMode {
        case SearchMode.SEARCH_BY_WORD:
            btnStr = "読み検索"
        case SearchMode.SEARCH_BY_READ:
            btnStr = "単語検索"
        }
        
        let changeSearchSettingBtn:UIBarButtonItem = UIBarButtonItem(title: btnStr, style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedChangeSearchModeButton))
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = changeSearchSettingBtn
    }

    override func viewWillAppear(_ animated: Bool) {
        let tabBarController:TabBarController = self.tabBarController as! TabBarController
        self.tabBarController?.title = tabBarController.m_barTitle
        setChangeSearchModeButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //各UIオブジェクトを配置
    func setUIObject() {
        
        let viewWidth:CGFloat = scrollView.frame.width
        let defaultMargin:CGFloat = 8
        let InputerLRMargin:CGFloat = 21
        let changeButtonWidth:CGFloat = 34
        let changeButtonHeight:CGFloat = 33
        let defaultButtonColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        var buttonY:CGFloat = 0
        
        //検索キーワード部分
        let keywordLabel = UILabel(frame: CGRect(x: 7, y: 12, width: 123, height: 24))
        keywordLabel.font = UIFont.systemFont(ofSize: 20)
        keywordLabel.text = "・キーワード"
        scrollView.addSubview(keywordLabel)
        buttonY = keywordLabel.frame.origin.y + keywordLabel.frame.height + defaultMargin
        
        let keywordInputField = UITextField(frame: CGRect(x: InputerLRMargin, y: buttonY, width: viewWidth - (InputerLRMargin * 2), height: 30))
        keywordInputField.delegate = self
        scrollView.addSubview(keywordInputField)
        keywordInputField.borderStyle = UITextBorderStyle.roundedRect
        buttonY = keywordInputField.frame.origin.y + keywordInputField.frame.height + defaultMargin
        
        //使用者 部分
        if (m_dataType != SearchDataType.SEARCH_DATA_MUSIC_ZUN) && (m_dataType != SearchDataType.SEARCH_DATA_MUSIC_NO_ZUN) {
            let userLabel = UILabel(frame: CGRect(x: 7, y: buttonY, width: 82, height: 24))
            userLabel.font = UIFont.systemFont(ofSize: 20)
            userLabel.text = "・使用者"
            scrollView.addSubview(userLabel)
            buttonY = userLabel.frame.origin.y + userLabel.frame.height + defaultMargin
            
            let userSettingLabel = UILabel(frame: CGRect(x: 33, y: buttonY, width: viewWidth - (33 + 10 + changeButtonWidth + InputerLRMargin), height: 1000))
            userSettingLabel.font = UIFont.systemFont(ofSize: 15)
            userSettingLabel.text = getUserAndTitleLabelText(labelIndex: 0)
            userSettingLabel.numberOfLines = 0
            userSettingLabel.sizeToFit()
            scrollView.addSubview(userSettingLabel)
            buttonY = userSettingLabel.frame.origin.y + userSettingLabel.frame.height + defaultMargin
            
            let setUserButton = UIButton(frame: CGRect(x: viewWidth - (changeButtonWidth + InputerLRMargin), y: userSettingLabel.frame.origin.y + (userSettingLabel.frame.height / 2) - (changeButtonHeight / 2), width: changeButtonWidth, height: changeButtonHeight))
            setUserButton.setTitle("変更", for: UIControlState.normal)
            setUserButton.setTitleColor(defaultButtonColor, for: UIControlState.normal)
            setUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            setUserButton.addTarget(self, action: #selector(tappedChangeSettingButton), for: .touchUpInside)
            setUserButton.tag = ButtonTag.CHANGE_USER_BUTTON.rawValue
            scrollView.addSubview(setUserButton)
        }
        
        //登場作品 部分
        let titleLabel = UILabel(frame: CGRect(x: 7, y: buttonY, width: 102, height: 24))
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "・登場作品"
        scrollView.addSubview(titleLabel)
        buttonY = titleLabel.frame.origin.y + titleLabel.frame.height + defaultMargin
        
        let titleSettingLabel = UILabel(frame: CGRect(x: 33, y: buttonY, width: viewWidth - (33 + 10 + changeButtonWidth + InputerLRMargin), height: 1000))
        titleSettingLabel.font = UIFont.systemFont(ofSize: 15)
        titleSettingLabel.text = getUserAndTitleLabelText(labelIndex: 1)
        titleSettingLabel.numberOfLines = 0
        titleSettingLabel.sizeToFit()
        scrollView.addSubview(titleSettingLabel)
        buttonY = titleSettingLabel.frame.origin.y + titleSettingLabel.frame.height + defaultMargin
        
        let setTitleButton = UIButton(frame: CGRect(x: viewWidth - (changeButtonWidth + InputerLRMargin), y: titleSettingLabel.frame.origin.y + (titleSettingLabel.frame.height / 2) - (changeButtonHeight / 2), width: changeButtonWidth, height: changeButtonHeight))
        setTitleButton.setTitle("変更", for: UIControlState.normal)
        setTitleButton.setTitleColor(defaultButtonColor, for: UIControlState.normal)
        setTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleButton.addTarget(self, action: #selector(tappedChangeSettingButton), for: .touchUpInside)
        setTitleButton.tag = ButtonTag.CHANGE_TITLE_BUTTON.rawValue
        scrollView.addSubview(setTitleButton)
        
        //並び順 部分
        let sortOrderLabel = UILabel(frame: CGRect(x: 7, y: buttonY, width: 82, height: 24))
        sortOrderLabel.font = UIFont.systemFont(ofSize: 20)
        sortOrderLabel.text = "・並び順"
        scrollView.addSubview(sortOrderLabel)
        buttonY = sortOrderLabel.frame.origin.y + sortOrderLabel.frame.height + defaultMargin
        
        let sortSettingLabel = UILabel(frame: CGRect(x: 33, y: buttonY, width: viewWidth - (33 + 10 + changeButtonWidth + InputerLRMargin), height: 1000))
        sortSettingLabel.font = UIFont.systemFont(ofSize: 15)
        sortSettingLabel.text = getUserAndTitleLabelText(labelIndex: 2)
        sortSettingLabel.numberOfLines = 0
        sortSettingLabel.sizeToFit()
        scrollView.addSubview(sortSettingLabel)
        buttonY = sortSettingLabel.frame.origin.y + sortSettingLabel.frame.height + defaultMargin
        
        let setSortOrderButton = UIButton(frame: CGRect(x: viewWidth - (changeButtonWidth + InputerLRMargin), y: sortSettingLabel.frame.origin.y + (sortSettingLabel.frame.height / 2) - (changeButtonHeight / 2), width: changeButtonWidth, height: changeButtonHeight))
        setSortOrderButton.setTitle("変更", for: UIControlState.normal)
        setSortOrderButton.setTitleColor(defaultButtonColor, for: UIControlState.normal)
        setSortOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setSortOrderButton.addTarget(self, action: #selector(tappedChangeSettingButton), for: .touchUpInside)
        setSortOrderButton.tag = ButtonTag.CHANGE_SORT_ORDER_BUTTON.rawValue
        scrollView.addSubview(setSortOrderButton)
        
        //検索ボタン 部分
        let searchButton = UIButton(frame: CGRect(x: (viewWidth / 2) - (150 / 2), y: buttonY + 30, width: 150, height: 48))
        searchButton.setTitle("単語検索", for: UIControlState.normal)
        searchButton.setTitleColor(defaultButtonColor, for: UIControlState.normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
        searchButton.tag = ButtonTag.SEARCH_BUTTON.rawValue
        scrollView.addSubview(searchButton)
    }
    
    //ラベルのテキスト設定
    func getUserAndTitleLabelText(labelIndex: Int) -> String {
    
        switch labelIndex {
        case 0:
            return "選択したキャラクター"
        case 1:
            return "選択した作品"
        case 2:
            return "選択した並び順"
        default:
            break
        }
     
        return ""
    }
    
    //変更ボタンが押された際に呼ばれる
    func tappedChangeSettingButton(sender: UIButton) {
        switch sender.tag {
        case ButtonTag.CHANGE_USER_BUTTON.rawValue:
            print("tapped chnage user button.")
        case ButtonTag.CHANGE_TITLE_BUTTON.rawValue:
            print("tapped chnage title button.")
        case ButtonTag.CHANGE_SORT_ORDER_BUTTON.rawValue:
            print("tapped chnage sort order button.")
        default:
            break
        }
    }
    
    //検索ボタンが押された際に呼ばれる
    func tappedSearchButton(sender: UIButton) {
        print("tapped search button.")
    }
    
    //検索モード切り替えボタンが押された際に呼ばれる
    func tappedChangeSearchModeButton(sender: UIButton) {
        
        let searchBtn = scrollView.viewWithTag(ButtonTag.SEARCH_BUTTON.rawValue) as! UIButton
        
        switch m_searchMode {
        case SearchMode.SEARCH_BY_WORD:
            m_searchMode = SearchMode.SEARCH_BY_READ
            searchBtn.setTitle("読み検索", for: UIControlState.normal)
        case SearchMode.SEARCH_BY_READ:
            m_searchMode = SearchMode.SEARCH_BY_WORD
            searchBtn.setTitle("単語検索", for: UIControlState.normal)
        }
        setChangeSearchModeButton()
    }
    
    //改行ボタンが押された際に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
