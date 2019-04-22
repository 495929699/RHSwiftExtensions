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

public extension UICollectionView {
    
    func register<Cell : UICollectionViewCell>(_ cell: Cell.Type) where Cell : ViewIdentifierType {
        register(cell, forCellWithReuseIdentifier: cell.ID)
    }
    
    func register<Cell : UICollectionReusableView>(_ cell: Cell.Type, forSupplementaryViewOfKind kind: SupplementaryViewOfKind) where Cell : ViewIdentifierType  {
        register(cell, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: cell.ID)
    }
    
    func dequeue<Cell : UICollectionViewCell>(_ reuseableCell: Cell.Type, for indexPath: IndexPath) throws -> Cell where Cell : ViewIdentifierType  {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseableCell.ID, for: indexPath) as? Cell else { throw UIError.dequeue }
        return cell
    }
    
    func dequeue<View : UICollectionReusableView>(_ reuseableCell: View.Type, ofKind kind: SupplementaryViewOfKind, for indexPath: IndexPath) throws -> View where View : ViewIdentifierType {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: reuseableCell.ID, for: indexPath) as? View else {
            throw UIError.dequeue
        }
        return view
    }
    
}
