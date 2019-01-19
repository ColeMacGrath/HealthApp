import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var textString: String {
        get {
            return noteTextView?.text ?? ""
        }
        set {
            if let textView = noteTextView {
                textView.text = newValue
                textViewDidChange(textView)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noteTextView?.isScrollEnabled = false
        noteTextView?.delegate = self
        titleLabel?.adjustsFontForContentSizeCategory = true
        noteTextView?.adjustsFontForContentSizeCategory = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            noteTextView?.becomeFirstResponder()
        } else {
            noteTextView?.resignFirstResponder()
        }
    }
}

extension NoteCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}
