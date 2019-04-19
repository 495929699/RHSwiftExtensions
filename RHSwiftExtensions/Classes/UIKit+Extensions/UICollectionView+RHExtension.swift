//
//  UICollectionView+RHExtension.swift
//  JYFW
//
//  Created by 荣恒 on 2019/1/19.
//  Copyright © 2019 荣恒. All rights reserved.
//

import UIKit

public extension UICollectionViewFlowLayout {
    
    /// 快捷初始化方法
    convenience init(itemSize: CGSize,
                     minimumLineSpacing: CGFloat = 0,
                     minimumInteritemSpacing: CGFloat = 0,
                     sectionInset: UIEdgeInsets? = nil,
                     headerReferenceSize: CGSize? = nil,
                     footerReferenceSize: CGSize? = nil,
                     scrollDirection: UICollectionView.ScrollDirection? = nil) {
        self.init()
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        if let sectionInset = sectionInset {
            self.sectionInset = sectionInset
        }
        if let headerReferenceSize = headerReferenceSize {
            self.headerReferenceSize = headerReferenceSize
        }
        if let footerReferenceSize = footerReferenceSize {
            self.footerReferenceSize = footerReferenceSize
        }
        if let scrollDirection = scrollDirection {
            self.scrollDirection = scrollDirection
        }
    }
    
}

extension UICollectionView {
    
    convenience init(layout : UICollectionViewLayout,
                     showsVerticalScrollIndicator : Bool = false,
                     showsHorizontalScrollIndicator : Bool = false,
                     alwaysBounceVertical : Bool = false,
                     alwaysBounceHorizontal : Bool = false,
                     bounces : Bool? = nil,
                     isScrollEnabled : Bool? = nil,
                     backgroundColor : UIColor? = nil,
                     contentInset : UIEdgeInsets? = nil,
                     dataSource : UICollectionViewDataSource? = nil,
                     delegate : UICollectionViewDelegate? = nil) {
        self.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.alwaysBounceVertical = alwaysBounceVertical
        self.alwaysBounceHorizontal = alwaysBounceHorizontal
        
        if let bounces = bounces {
            self.bounces = bounces
        }
        if let isScrollEnabled = isScrollEnabled {
            self.isScrollEnabled = isScrollEnabled
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
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

public enum SupplementaryViewOfKind: String {
    case header, footer
    
    public init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {
    
    public func register<Cell : UICollectionViewCell>(cell: Cell.Type) where Cell : ViewIdentifierType {
        register(cell, forCellWithReuseIdentifier: cell.ID)
    }
    
    public func register<Cell : UICollectionReusableView>(cell: Cell.Type, forSupplementaryViewOfKind kind: SupplementaryViewOfKind) where Cell : ViewIdentifierType  {
        register(cell, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: cell.ID)
    }
    
    public func dequeue<Cell : UICollectionViewCell>(_ reuseableCell: Cell.Type, for indexPath: IndexPath) -> Cell? where Cell : ViewIdentifierType  {
        return dequeueReusableCell(withReuseIdentifier: reuseableCell.ID, for: indexPath) as? Cell
    }
    
    public func dequeue<View : UICollectionReusableView>(_ reuseableCell: View.Type, ofKind kind: SupplementaryViewOfKind, for indexPath: IndexPath) -> View? where View : ViewIdentifierType {
        return dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: reuseableCell.ID, for: indexPath) as? View
    }
    
}
