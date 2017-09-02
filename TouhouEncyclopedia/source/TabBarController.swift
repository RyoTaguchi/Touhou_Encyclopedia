//
//  TabBarController.swift
//  TouhouEncyclopedia
//
//  Created by ganeme816 on 2017/08/20.
//  Copyright © 2017年 RyoTaguchi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    public enum TabMode : Int {
        case MODE_INIT_VALUE   = 0
        //
        case MODE_SPELL        = 1
        case MODE_SKILL        = 2
        case MODE_SHOT         = 3
        case MODE_MUSIC_ZUN    = 4
        case MODE_MUSIC_NO_ZUN = 5
        case MODE_TALKS        = 6
    }
    
    public var m_mode:TabMode = TabMode.MODE_INIT_VALUE
    public var m_displayTabIndex:Int = 0
    public var m_barTitle:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setTabInfo(selectedTabIndex: selectedIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch m_mode {
        case TabMode.MODE_SPELL, TabMode.MODE_SKILL, TabMode.MODE_SHOT:
            if item.title == "タイトル別" {
                setTabInfo(selectedTabIndex: 1)
            } else if item.title == "キャラクター別" {
                setTabInfo(selectedTabIndex: 2)
            } else {
                setTabInfo(selectedTabIndex: 0)
            }
    
        case TabMode.MODE_MUSIC_ZUN:
            if item.title == "タイトル別" {
                setTabInfo(selectedTabIndex: 1)
            } else {
                setTabInfo(selectedTabIndex: 0)
            }
            
        default:
            break
        }
    }
    
    func setTabInfo(selectedTabIndex: Int) {
        
        var tmp:String = ""
        
        switch m_mode {
        case TabMode.MODE_SPELL:
            tmp = "スペルカード"
        case TabMode.MODE_SKILL:
            tmp = "スキル"
        case TabMode.MODE_SHOT:
            tmp = "ショット"
        case TabMode.MODE_MUSIC_ZUN:
            tmp = "楽曲"
        case TabMode.MODE_MUSIC_NO_ZUN:
            tmp = "楽曲（非ZUN曲）"
        case TabMode.MODE_TALKS:
            tmp = "会話"
        default:
            break
        }
        
        switch m_mode {
        case TabMode.MODE_SPELL, TabMode.MODE_SKILL, TabMode.MODE_SHOT:
            if selectedTabIndex == 1 {
                m_displayTabIndex = 1
                m_barTitle = tmp + " - タイトル別"
            } else if selectedTabIndex == 2 {
                m_displayTabIndex = 2
                m_barTitle = tmp + " - キャラクター別"
            } else {
                m_displayTabIndex = 0
                m_barTitle = tmp + " - 検索"
            }
        case TabMode.MODE_MUSIC_ZUN:
            if selectedTabIndex == 1 {
                m_displayTabIndex = 1
                m_barTitle = tmp + " - タイトル別"
            } else {
                m_displayTabIndex = 0
                m_barTitle = tmp + " - 検索"
            }
        default:
            break
        }
    }

}
