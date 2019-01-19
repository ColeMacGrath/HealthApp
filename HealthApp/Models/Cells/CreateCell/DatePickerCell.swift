import UIKit

class DatePickerCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let actualDate = Date()
        datePicker.minimumDate = actualDate
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: actualDate)
    }
}
