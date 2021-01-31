//
//  PostTableViewCell.swift
//  RaketaSwiftChallenge
//
//  Created by vhlohov on 31.01.2021.
//

import UIKit

protocol PostTableViewCellDelegate : class {
    func postCellThumbnailTapped(cell:PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
   
    static let identifier = "PostTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var numberOfcommentsLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    weak var delegate: PostTableViewCellDelegate?
    
    override func prepareForReuse() {
        thumbnailImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGesture()
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    func reset() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func applyData(data: PostChildrenEntity)  {
        titleLabel.text = data.title
        authorLabel.text = data.author
        timeAgoLabel.text =  data.timeAgo
        thumbnailImageView.loadImage(urlString: data.thumbnail) {
            [weak self] (isFinish) in
            guard let strongSelf = self else {return}
            if isFinish{
                strongSelf.activityIndicatorView.stopExecutionOnAMainThread()
                strongSelf.activityIndicatorView.isHidden = true
                return
            }
            self?.thumbnailImageView.image = UIImage(named: "reddit")
        }
        numberOfcommentsLabel.text = "\(data.comments)"
    }
    
    
    private func setGesture() {
        self.isUserInteractionEnabled = true
        let thumbnailImageViewGetsure = UITapGestureRecognizer(
            target: self,
            action: #selector(thumbnailImageViewTapped))
        thumbnailImageView.addGestureRecognizer(thumbnailImageViewGetsure)
    }
    
    @objc private func thumbnailImageViewTapped() {
        delegate?.postCellThumbnailTapped(cell: self)
    }
    
}

