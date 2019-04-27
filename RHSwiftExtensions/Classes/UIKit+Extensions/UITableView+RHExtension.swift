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
    
    func register<Cell : UITableViewCell>(_ cell: Cell.Type) where Cell : ViewIdentifierType {
        register(cell, forCellReuseIdentifier: Cell.ID)
    }
    
    func register<View : UITableViewHeaderFooterView>(_ view: View.Type) where View : ViewIdentifierType  {
        register(view, forHeaderFooterViewReuseIdentifier: View.ID)
    }
    
    func dequeue<Cell : UITableViewCell>(_ reusableCell: Cell.Type) -> Cell? where Cell : ViewIdentifierType {
        return dequeueReusableCell(withIdentifier: reusableCell.ID) as? Cell
    }
    
    func dequeue<Cell : UITableViewCell>(_ resusableCell: Cell.Type, for indexPath: IndexPath) throws -> Cell where Cell: ViewIdentifierType {
        guard let cell = dequeueReusableCell(withIdentifier: resusableCell.ID, for: indexPath) as? Cell else {
            throw UIError.dequeue
        }
        return cell
    }
    
    func dequeue<View : UITableViewHeaderFooterView>(_ reusableCell: View.Type) throws -> View where View : ViewIdentifierType {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: reusableCell.ID) as? View else {
            throw UIError.dequeue
        }
        return cell
    }
    
}
