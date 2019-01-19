import UIKit
import FirebaseAuth

class ExpandedInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    
    var patient: Patient!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            self.present(viewController, animated: false, completion: nil)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = patient.username
        genderLabel.text = patient.biologicalSex
        profileImageView.image = patient.profilePicture
        profileImageView.setRounded()
        loadSections()
    }
    
    func loadSections() {
        var hearthData: [String] = []
        var execerciseData: [String] = []
        var sleepData: [String] = []
        var heightData: [String] = []
        var weightData: [String] = []
        var stringToFormat = ""
        
        for hearthRecord in patient.hearthRecords {
            stringToFormat = "\(hearthRecord.bpm) - \(hearthRecord.endDate)"
            hearthData.append(stringToFormat)
        }
        
        for exerciseRecord in patient.workoutRecords {
            stringToFormat = "\(exerciseRecord.time) - \(exerciseRecord.calories) calories"
            execerciseData.append(stringToFormat)
        }
        
        for sleepRecord in patient.sleepRecords {
            stringToFormat = "\(sleepRecord.hoursSleeping) hours - \(sleepRecord.startDate)"
            sleepData.append(stringToFormat)
        }
        
        for weightRecord in patient.weightRecords {
            stringToFormat = "\(weightRecord.weight) - \(weightRecord.startDate)"
            weightData.append(stringToFormat)
        }
        
        for heightRecord in patient.heightRecords {
            stringToFormat = "\(heightRecord.height) - \(heightRecord.startDate)"
            heightData.append(stringToFormat)
        }
        sections = [
            Section(type: "❤️ \(NSLocalizedString("table.heart", comment: ""))", data: hearthData, expanded: false),
            Section(type: "🏋️‍♀️ \(NSLocalizedString("table.exercise", comment: ""))", data: execerciseData, expanded: false),
            Section(type: "💤 \(NSLocalizedString("table.sleep", comment: ""))", data: sleepData, expanded: false),
            Section(type: "📏 \(NSLocalizedString("table.Height", comment: ""))", data: heightData, expanded: false),
            Section(type: "⚖️ \(NSLocalizedString("table.Weight", comment: ""))", data: weightData, expanded: false)
        ]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].expanded {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].type, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].data[indexPath.row]
        return cell
    }

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].data.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}
