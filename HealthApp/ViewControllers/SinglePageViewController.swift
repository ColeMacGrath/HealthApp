import UIKit

struct GenericDataHealthType {
    private var _data: String
    private var _detail: String
    
    init(data: String, detail: String) {
        _data = data
        _detail = detail
    }
    
    var data:   String { return _data }
    var detail: String { return _detail }
    
}

class SinglePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var patient: Patient!
    var arrayToShow: [AnyObject]!
    var finalArray = [GenericDataHealthType]()
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.finalArray = getFinal(array: self.arrayToShow)
        valueLabel.text = finalArray.last?.data
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getFinal(array: [AnyObject]) -> [GenericDataHealthType] {
        var castedArray: [GenericDataHealthType] = []
        if let array = array as? [HearthRecord] {
            for hearthRecord in array {
                let genericDataType = GenericDataHealthType(data: "\(hearthRecord.bpm) BMP", detail: hearthRecord.startDate.formattedDate)
                castedArray.append(genericDataType)
            }
        } else if let array = array as? [SleepAnalisys] {
            for sleepAnalisys in array {
                let genericDataType = GenericDataHealthType(data: sleepAnalisys.hoursSleeping, detail: sleepAnalisys.startDate.formattedDate)
                castedArray.append(genericDataType)
            }
            
        } else if let array = array as? [WorkoutRecord] {
            for workoutRecord in array {
                let genericDataType = GenericDataHealthType(data: "\(workoutRecord.calories) Cal", detail: workoutRecord.time)
                castedArray.append(genericDataType)
            }
            
        } else if let array = array as? [Weight] {
            for weightRecord in array {
                let genericDataType = GenericDataHealthType(data: "\(weightRecord.weight) Lb", detail: weightRecord.startDate.formattedDate)
                castedArray.append(genericDataType)
            }
            
        } else if let array = array as? [Height] {
            for heightRecord in array {
                print(heightRecord.height)
                let genericDataType = GenericDataHealthType(data: "\(heightRecord.height) Mt", detail: heightRecord.startDate.formattedDate)
                castedArray.append(genericDataType)
            }
        }
        return castedArray
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let healthDataType = finalArray[indexPath.row]
        let cellID = "healthTypeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HealthTypeCell
        
        cell.dataLabel.text = healthDataType.data
        cell.detailLabel.text = healthDataType.detail
        
        return cell
    }
    
}
