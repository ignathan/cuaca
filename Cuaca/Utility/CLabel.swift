//
//  CLabel.swift
//  Cuaca
//
//  Created by Ignatius Nathan on 03/10/2022.
//

import UIKit

class CLabel: UILabel {
    
    enum Style {
        case title
        case content
    }
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .primaryText
    }
    
    convenience init(style: Style) {
        self.init()
        
        switch style {
        case .title:
            font = .systemFont(ofSize: 18)
        case .content:
            font = .boldSystemFont(ofSize: 36)
        }
    }
    
    convenience init(size: CGFloat) {
        self.init()
        
        font = .systemFont(ofSize: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
