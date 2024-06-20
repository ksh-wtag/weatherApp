import UIKit

class CustomDayForecastCellTableViewCell: UITableViewCell {

    @IBOutlet weak var upcomingDays: UILabel!
    @IBOutlet weak var upcomingDescriptionIcon: UIImageView!
    @IBOutlet weak var UpcomingTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
