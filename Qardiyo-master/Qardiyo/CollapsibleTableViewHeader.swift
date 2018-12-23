//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        

        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = UIColor.white
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Title label
        contentView.addBorder(toSide: .bottom, withColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), andThickness: 6)
    //    contentView.layer.addBorder(edge: UIRectEdge.top, color: .white, thickness: 4)
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
      //  titleLabel.backgroundColor = .red
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        titleLabel.numberOfLines = 0
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 1))
     //   label.center = CGPoint(x: 160, y: 285)
      //  label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      //  label.text = "I'am a test label"
        contentView.addSubview(label)

        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }
    
}
