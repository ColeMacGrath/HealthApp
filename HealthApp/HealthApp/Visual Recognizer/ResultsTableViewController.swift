import UIKit
import Vision

class ResultsTableViewController: UITableViewController {
    
    
    var classifications = [VNClassificationObservation]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.removeExtraLines()
        self.tableView.estimatedRowHeight = 85.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell
        
        if indexPath.item == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellLarge", for: indexPath) as! ResultTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellDefault", for: indexPath) as! ResultTableViewCell
        }
        
        let score = self.classifications[indexPath.item].confidence
        
        cell.label.text = self.classifications[indexPath.item].identifier
        cell.progress.progress = CGFloat(score)
        cell.score.text = "\(String(format: "%.0f", score*100))%"
        
        return cell
    }
}

extension ResultsTableViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat {
        return 68.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat {
        return 264.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
        return PulleyPosition.all
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController) {
        tableView.isScrollEnabled = drawer.drawerPosition == .open
    }
}
