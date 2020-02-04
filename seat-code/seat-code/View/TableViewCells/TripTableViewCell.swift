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
            self.tripStatus.backgroundColor = self.getStatusIcon(status: self.cellTrip.status)
            self.tripDescription.text = self.cellTrip.description
            self.tripInfo.attributedText = self.getTripInfo(trip: self.cellTrip)
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
    
    private func getTimeDifference(start: Date, end: Date) -> String {
        
        let difference = start.differenceHoursAndMinutes(between: end)
        
        var hours = "\(difference.hour!)"
        if difference.hour! < 10 {
            hours = "0\(difference.hour ?? 0)"
        }
        
        var minutes = "\(difference.minute!)"
        if difference.minute! < 10 {
            minutes = "0\(difference.minute ?? 0)"
        }
        
        
        return "\(hours):\(minutes)"
    }
    
    private func getTripInfo(trip: Trip) -> NSMutableAttributedString {
        let startTime = trip.startTime.toString(dateFormat: "HH:mm")
        
        let timeDifference = getTimeDifference(start:trip.startTime, end: trip.endTime)
        
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let normalAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        // Starts: 08:00 / Duration: 1h (6 stops)
        let mutableString = NSMutableAttributedString(string: "Salida: ", attributes: boldAttribute)
        let startTimeString = NSMutableAttributedString(string: startTime, attributes: normalAttribute)
        let separatorString = NSMutableAttributedString(string: " / ", attributes: normalAttribute)
        let durationString = NSMutableAttributedString(string: "Duración:", attributes: boldAttribute)
        let durationValueString = NSMutableAttributedString(string: " \(timeDifference) ", attributes: normalAttribute)
        let stopString = NSMutableAttributedString(string: "(\(trip.stops.count) stops)", attributes: boldAttribute)
        
        mutableString.append(startTimeString)
        mutableString.append(separatorString)
        mutableString.append(durationString)
        mutableString.append(durationValueString)
        mutableString.append(stopString)
        
        return mutableString
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
