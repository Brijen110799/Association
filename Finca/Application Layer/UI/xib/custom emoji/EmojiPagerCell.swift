//
//  EmojiPagerCell.swift
//  Finca
//
//  Created by Silverwing Technologies on 15/04/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import UIKit

protocol EmojiClick {
    func onClickEmoji(emoji : String)
}
class EmojiPagerCell: UIView {

    
    @IBOutlet weak var cvData: UICollectionView!
    let itemcell = "EmojiCell"
      
     var emoji_category = [EmojiCategory]()
    var emojiClick : EmojiClick!
    override func draw(_ rect: CGRect) {
        // Drawing code
        let nib = UINib(nibName: itemcell, bundle: nil)
        cvData.register(nib, forCellWithReuseIdentifier: itemcell)
        cvData.delegate = self
        cvData.dataSource = self
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setListData(emoji_category : [EmojiCategory]) {
       
        self.emoji_category  = emoji_category
        print("ddd stesetesehdghse" , emoji_category.count)
        cvData.reloadData()
    }
}
extension EmojiPagerCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji_category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath)as! EmojiCell
        cell.lbEmoji.text = emoji_category[indexPath.row].character
        cell.viewLine.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourwidth = collectionView.frame.width/8
        return CGSize(width: yourwidth-1 , height: yourwidth)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emojiClick.onClickEmoji(emoji: emoji_category[indexPath.row].character)
       
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//         let cell: WeekDaysCell = cvdata.cellForItem(at: indexPath) as! WeekDaysCell
          
    }
}

