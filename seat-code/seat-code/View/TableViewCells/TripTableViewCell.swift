//
//  TripTableViewCell.swift
//  seat-code
//
//  Created by Daniel Castro on 03/02/2020.
//  Copyright © 2020 Sephirot36. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    // MARK: - @IBOutlets
    
    @IBOutlet var tripStatus: UIImageView!
    @IBOutlet var tripDescription: UILabel!
    @IBOutlet var tripInfo: UILabel!
    
    // MARK: - Variables
    
    public var cellTrip: Trip! {
        didSet {
            self.tripDescription.text = self.cellTrip.description
            self.tripInfo.text = self.cellTrip.startTime
            self.tripStatus.backgroundColor = getStatusIcon(status: self.cellTrip.status)
        }
    }
    
    // MARK: - Private methods
    
    private func getStatusIcon(status: RouteStatus) -> UIColor {
        switch status {
        case .ongoing:
            return UIColor.green
        case .scheduled:
            return UIColor.orange
        case .finalized:
            return UIColor.black
        case .canceled:
            return UIColor.red
        default:
            return UIColor.yellow
        }
    }
    
    // MARK: - UITableViewCell lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
