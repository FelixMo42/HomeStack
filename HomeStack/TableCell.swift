import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet var view: UIView!
    @IBOutlet var name: UILabel!
    @IBOutlet var teacherName: UILabel!
    @IBOutlet var period: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

