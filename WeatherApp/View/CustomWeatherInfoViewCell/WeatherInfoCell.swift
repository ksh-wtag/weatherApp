import UIKit

class WeatherInfoCell: UITableViewCell {
    
    @IBOutlet weak var weatherInfoTitle: UILabel!
    @IBOutlet weak var weatherInfoValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
