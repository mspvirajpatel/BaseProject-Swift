//
//  SpeakerTableViewCell.swift
//  ViewControllerDemo
//
//  Created by Viraj Patel on 01/07/16.
//  Copyright @ 2017 Viraj Patel. All rights reserved.
//

import UIKit

class SpeakerTableViewCell: UITableViewCell {

    // MARK: - Attributes -
    
    var profileImageView : BaseImageView!
    var userNameLabel : BaseLabel!
    
    var userPositionLabel : BaseLabel!
    var userCompanyLabel : BaseLabel!
    
    var userEmailIDLabel : BaseLabel!
    var userAddressLabel : BaseLabel!
    
    var baseLayout : AppBaseLayout!
    
    // MARK: - Lifecycle -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted){
            self.contentView.backgroundColor = UIColor(rgbValue: 0x111111, alpha: 0.4)
            
        }else{
            self.contentView.backgroundColor = UIColor.clear
            
        }
    }
    
    deinit{
        
        profileImageView = nil
        userNameLabel = nil
    
        userPositionLabel = nil
        userCompanyLabel = nil
        
        userEmailIDLabel = nil
        userAddressLabel = nil
        
        baseLayout = nil
    
    }
    
    // MARK: - Layout - 
    
    func loadViewControls(){
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = false
        
        self.accessoryType = .none
        self.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
        self.clipsToBounds = false
        
    }
    
    func setViewControlslayout(){
        
        if(false){
            
        }
        
        baseLayout = AppBaseLayout()
        baseLayout = nil
        
    }
    
    // MARK: - Public Interface -
    
    func displaySpeakerDetails(_ iSpeaker : Speaker){
        
    }
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
