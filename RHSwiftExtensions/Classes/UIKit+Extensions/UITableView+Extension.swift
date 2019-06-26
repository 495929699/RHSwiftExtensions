//
//  UITableView+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/19.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit


public extension UITableView {
    
    /// UITableView快捷初始化方法。自动增加内边距未设置。安全区域未设置
    ///
    /// - Parameters:
    ///   - estimatedRowHeight: 切记iOS11 下要设置为0.设置为其他数值会有好多坑（上拉，下拉，刷新都会有问题）
    ///   - estimatedSectionHeaderHeight: 对iOS11 适配。iOS11 下面两个属性默认值改了
    ///   - estimatedSectionFooterHeight: 对iOS11 适配。iOS11 下面两个属性默认值改了
    convenience init(style : UITableView.Style = .plain,
                     showsVerticalScrollIndicator : Bool = false,
                     estimatedRowHeight : CGFloat = 0,
                     estimatedSectionHeaderHeight : CGFloat = 0,
                     estimatedSectionFooterHeight : CGFloat = 0,
                     separatorStyle : UITableViewCell.SeparatorStyle = .none,
                     bounces : Bool? = nil,
                     backgroundColor : UIColor? = nil,
                     rowHeight : CGFloat? = nil,
                     contentInset : UIEdgeInsets? = nil,
                     dataSource : UITableViewDataSource? = nil,
                     delegate : UITableViewDelegate? = nil) {
        self.init(frame: CGRect.zero, style: style)
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.estimatedRowHeight = estimatedRowHeight
        
        self.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        self.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        
        self.separatorStyle = separatorStyle
        
        if let bounces = bounces {
            self.bounces = bounces
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let rowHeight = rowHeight {
            self.rowHeight = rowHeight
        }
        if let contentInset = contentInset {
            self.contentInset = contentInset
        }
        if let dataSource = dataSource {
            self.dataSource = dataSource
        }
        if let delegate = delegate {
            self.delegate = delegate
        }
    }
    
}


public extension UITableView {
    
    /// 注册UITableViewCell，不需要Identifier。内部已实现唯一标识
    func register<Cell : UITableViewCell>(_ cell: Cell.Type) {
        register(cell, forCellReuseIdentifier: Cell.ID)
    }
    
    /// 批量注册UITableViewCell
    func registers<Cell : UITableViewCell>(_ cells: Cell.Type...) {
        cells.forEach { register($0) }
    }
    
    func register<View : UITableViewHeaderFooterView>(_ view: View.Type)  {
        register(view, forHeaderFooterViewReuseIdentifier: View.ID)
    }
    
    func dequeue<Cell : UITableViewCell>(_ resusableCell: Cell.Type, for indexPath: IndexPath) throws -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: resusableCell.ID, for: indexPath) as? Cell
            else { throw NSError() }
        return cell
    }
    
}
