import UIKit
import FirebaseDatabase
import FirebaseAuth
import HealthKit
import SCLAlertView

let healthKitStore: HKHealthStore = HKHealthStore()

enum MeasurementUnit: Int {
    case pound = 0
    case kilogram = 1
    case meter = 2
    case feet = 3
}

enum HealthValue: Int {
    case weight = 0
    case height = 1
    case hearth = 2
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var sleepHoursLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var exerciseTimeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var myDoctorsButton: UIButton!
    @IBOutlet weak var linesStackView: UIStackView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var updatePictureButton: UIButton!
    @IBOutlet weak var savePictureButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var patient: Patient?
    let patientUid: String? = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKitInApp()
        
        getPatientDetails()
        sendWithDelay()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            patient?.firstName = firstName
            patient?.lastName = lastName
            sendWithDelay()
        }
        
        firstNameTextField.isEnabled = false
        firstNameTextField.isHidden = true
        lastNameTextField.isEnabled = false
        lastNameTextField.isHidden = true
        savePictureButton.isEnabled = false
        savePictureButton.isHidden = true
        updatePictureButton.isEnabled = false
        updatePictureButton.isHidden = true
        profilePictureImageView.isUserInteractionEnabled = true
        nameLabel.isHidden = false
        infoButton.isEnabled = true
        infoButton.isHidden = false
        linesStackView.isHidden = true
        
        profilePictureImageView.alpha = 1.0
    }
    
    @IBAction func updateProfilePictureButtonPressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            } else {
                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {})
                alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            } else {
                let appearance = SCLAlertView.SCLAppearance( showCloseButton: false )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("OK", action: {})
                alert.showError("Error", subTitle: NSLocalizedString("QRAnalyzer.error", comment: ""))
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        profilePictureImageView.image = image
        patient?.profilePicture = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        nameLabel.isHidden = true
        infoButton.isEnabled = false
        infoButton.isHidden = true
        firstNameTextField.isEnabled = true
        firstNameTextField.isHidden = false
        lastNameTextField.isEnabled = true
        lastNameTextField.isHidden = false
        savePictureButton.isEnabled = true
        savePictureButton.isHidden = false
        updatePictureButton.isEnabled = true
        updatePictureButton.isHidden = false
        profilePictureImageView.isUserInteractionEnabled = false
        linesStackView.isHidden = false
        
        profilePictureImageView.alpha = 0.5
        firstNameTextField.text = patient?.firstName
        lastNameTextField.text = patient?.lastName
    }
    
    func sendWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (self.patient?.username.count)! < 3 {
                self.sendWithDelay()
                return
            }
            DatabaseService.shared.addInfoFromHealthKit(patient: self.patient!)
        }
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        //DatabaseService.shared.addInfoFromHealthKit(patient: patient!)
        performSegue(withIdentifier: "detailPageVC", sender: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCameraVC", sender: nil)
    }
    
    @IBAction func moreDetailsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showDoctorsVC", sender: nil)
    }
    
    func getPatientDetails() {
        let (age, bloodType, biologicalSex) = getBasicData()
        getName()
        
        patient = Patient(uid: patientUid!)
        patient?.profilePicture = UIImage(named: "picture")!
        patient?.age = age ?? 0
        patient?.biologicalSex = getReadable(biologicalSex: biologicalSex) ?? NSLocalizedString("profile.notDefined", comment: "")
        patient?.bloodType = getReadable(bloodType: bloodType?.bloodType)
        
        ageLabel.text = "\(String(describing: age!))"
        bloodTypeLabel.text = getReadable(bloodType: bloodType?.bloodType)
        genderLabel.text = getReadable(biologicalSex: biologicalSex)
        profilePictureImageView.image = patient?.profilePicture
        profilePictureImageView.setRounded()
        
        weightRecords(from: Date(timeIntervalSince1970: TimeInterval()), to: Date().endOfDay)
        heightRecords(from: Date(timeIntervalSince1970: TimeInterval()), to: Date().endOfDay)
        getSleepAnalysis(from: Date(timeIntervalSince1970: TimeInterval()), to: Date().endOfDay)
        getStepsCount(forSpecificDate: Date()) { (steps) in
            DispatchQueue.main.async(execute: { () -> Void in
                if steps >= 1.0 {
                    DispatchQueue.main.async {
                        self.stepsLabel.text = "\(Int(steps))"
                        self.patient?.steps = Int(steps)
                    }
                }
            })
        }
        getHearthRate(from: Date(timeIntervalSince1970: TimeInterval()), to: Date().endOfDay)
        getActiveEnergy()
    }
    
    //MARK: - Authorization methods
    
    func authorizeHealthKitInApp() {
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.activitySummaryType()
        ]
        
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        ]
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error ocurred")
            return
        }
        
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (sucess, error) -> Void in
            print("Read Write Authoriazation succeded")
        }
    }
    
    //MARK: - HealthKit Methods for get info
    
    func getBasicData() -> (age: Int?, bloodType: HKBloodTypeObject?, biologicalSex: HKBiologicalSexObject?) {
        var age: Int?
        var bloodType: HKBloodTypeObject?
        var biologicalSex: HKBiologicalSexObject?
        do {
            let birthDay = try healthKitStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            age = currentYear - birthDay.year!
        } catch {
            age = 21
        }
        
        do {
            bloodType = try healthKitStore.bloodType()
            biologicalSex = try healthKitStore.biologicalSex()
        } catch {
            //Algo salió mal al leer el perfil
        }
        return (age, bloodType, biologicalSex)
    }
    
    func getReadable(bloodType: HKBloodType?) -> String {
        var bloodTypeText = ""
        
        if bloodType != nil {
            switch(bloodType!) {
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break
            }
        }
        
        return bloodTypeText
    }
    
    func getReadable(biologicalSex: HKBiologicalSexObject?) -> String? {
        var readeableBiologicalSex: String?
        if let sex = biologicalSex?.biologicalSex {
            switch sex {
            case .notSet:
                readeableBiologicalSex = NSLocalizedString("profile.notDefined", comment: "")
            case .female:
                readeableBiologicalSex = NSLocalizedString("profile.female", comment: "")
            case .male:
                readeableBiologicalSex = NSLocalizedString("profile.male", comment: "")
            case .other:
                readeableBiologicalSex = NSLocalizedString("profile.other", comment: "")
            }
        } else {
            return nil
        }
        
        return readeableBiologicalSex
    }
    
    func weightRecords(from: Date, to: Date) {
        let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                if result.startDate >= from && result.endDate <= to {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let formatedWeight = self.getFormated(sample: result, forValue: HealthValue.weight)
                        let weight = Weight(weight: formatedWeight as! Double, startDate: result.startDate, endDate: result.endDate)
                        let weightToShow = self.getFormated(measure: formatedWeight as! Double, on: MeasurementUnit.kilogram)
                        self.weightLabel.text = weightToShow
                        self.patient?.add(weightRecord: weight)
                    })
                }
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func heightRecords(from: Date, to: Date) {
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.last as? HKQuantitySample {
                if result.startDate >= from && result.endDate <= to {
                    DispatchQueue.main.async(execute: { () -> Void in
                        let formatedHeight = self.getFormated(sample: result, forValue: HealthValue.height)
                        let height = Height(height: formatedHeight as! Double, startDate: result.startDate, endDate: result.endDate)
                        self.heightLabel.text = self.getFormated(measure: formatedHeight as! Double, on: MeasurementUnit.meter)
                        self.patient?.add(heightRecord: height)
                    })
                }
            } else {
                print("OOPS didnt get height \nResults => \(String(describing: results)), error => \(String(describing: error))")
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func getSleepAnalysis(from: Date, to: Date) {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if error != nil {
                    return
                }
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            if sample.startDate >= from && sample.endDate <= to {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    let sleepAnalisys = SleepAnalisys(startDate: sample.startDate, endDate: sample.endDate)
                                    self.sleepHoursLabel.text = "\(sleepAnalisys.hoursSleeping)"
                                    self.patient?.add(sleepRecord: sleepAnalisys)
                                })
                            }
                        }
                    }
                }
            }
            healthKitStore.execute(query)
        }
    }
    
    func getHearthRate(from: Date, to: Date) {
        let hearthRateSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        let query = HKSampleQuery(sampleType: hearthRateSample!, predicate: .none, limit: 0, sortDescriptors: nil) { query, results, error in
            if results?.count ?? 0 > 0 {
                for result in results as! [HKQuantitySample] {
                    if result.startDate >= from && result.endDate <= to {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let formatedResult = self.getFormated(sample: result, forValue: HealthValue.hearth)
                            let hearthRecord = HearthRecord(bpm: formatedResult as! Int, startDate: result.startDate, endDate: result.endDate)
                            self.bpmLabel.text = "\(formatedResult)"
                            self.patient?.add(hearthRecord: hearthRecord)
                        })
                    }
                }
            }
        }
        healthKitStore.execute(query)
    }
    
    func getActiveEnergy () {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -5, to: endDate)
        
        let energySampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: energySampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (query, results, error) in
            if results == nil {
                print("There was an error running the query => \(String(describing: error))")
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let last = results?.last as? HKQuantitySample {
                    self.caloriesLabel.text = "\(Int(last.quantity.doubleValue(for: HKUnit.kilocalorie())))"
                    for activity in results as! [HKQuantitySample] {
                        let totalActiveEnergy = activity.quantity.doubleValue(for: HKUnit.kilocalorie())
                        let activity = WorkoutRecord(startDate: activity.startDate, endDate: activity.endDate, caloriesBurned: totalActiveEnergy)
                        self.patient?.add(workoutRecord: activity)
                    }
                }
            })
        })
        healthKitStore.execute(query)
    }
    
    func getStepsCount(forSpecificDate: Date, completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let (start, end) = self.getWholeDate(date: forSpecificDate)
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthKitStore.execute(query)
    }
    
    //MARK: - Write Methods
    
    func writeHeight() {
        let height = 1.80
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit.meter(), doubleValue: Double(height))
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            healthKitStore.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(String(describing: error))")
            })
        }
    }
    
    func saveHeartRate(date: Date = Date(), heartRate heartRateValue: Double, completion completionBlock: @escaping (Bool, Error?) -> Void) {
        let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let quantity = HKQuantity(unit: unit, doubleValue: heartRateValue)
        let type = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let heartRateSample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        
        healthKitStore.save(heartRateSample) { (success, error) -> Void in
            if !success {
                print("An error occured saving the HR sample \(heartRateSample). In your app, try to handle this gracefully. The error was: \(String(describing: error)).")
            }
            completionBlock(success, error)
        }
    }
    
    //MARK: - Utilities for get data Formated
    
    func getWholeDate(date: Date) -> (startDate:Date, endDate: Date) {
        var startDate = date
        var length = TimeInterval()
        _ = Calendar.current.dateInterval(of: .day, start: &startDate, interval: &length, for: startDate)
        let endDate:Date = startDate.addingTimeInterval(length)
        return (startDate, endDate)
    }
    
    func getFormated(measure: Double, on: MeasurementUnit) -> String {
        var formatedMeasure = ""
        var convertedUnit = 0.0
        switch on {
        case .feet:
            convertedUnit = measure * 0.032808
            formatedMeasure = "\(convertedUnit.rounded()) ft"
            break
        case .kilogram:
            convertedUnit = measure / 2.205
            //convertedUnit = measure / 1000
            formatedMeasure = "\(convertedUnit.rounded()) kg"
        case .meter:
            if measure < 100 {
                formatedMeasure = "\(measure) M"
            } else {
                convertedUnit = measure / 100
                formatedMeasure = "\(convertedUnit) M"
            }
        case .pound:
            convertedUnit = measure / 453.592
            formatedMeasure = "\(convertedUnit.rounded()) lb"
        }
        return formatedMeasure
    }
    
    func getFormated(sample: HKQuantitySample, forValue: HealthValue) -> AnyObject {
        var toFormat = "\(sample.quantity)"
        switch forValue {
        case .hearth:
            toFormat = toFormat.replacingOccurrences(of: " count/min", with: "")
            if let formated = Int(toFormat) {
                return formated as AnyObject
            } else {
                return 0.0 as AnyObject
            }
        case .height:
             toFormat = toFormat.replacingOccurrences(of: " cm", with: "")
             toFormat = toFormat.replacingOccurrences(of: " m", with: "")
             if let formated = Double(toFormat) {
                return formated as AnyObject
             } else {
                return 0.0 as AnyObject
            }
        case .weight:
            if toFormat.contains("lb") {
                toFormat = toFormat.replacingOccurrences(of: " lb", with: "")
                if let formated = Double(toFormat) {
                    return formated as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            } else if toFormat.contains("g") {
                toFormat = toFormat.replacingOccurrences(of: " g", with: "")
                if let formated = Double(toFormat) {
                    return formated as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            } else {
                if (Double(toFormat) != nil) {
                    return toFormat as AnyObject
                } else {
                    return 0.0 as AnyObject
                }
            }
            
        }
    }
    
    //MARK: - Sending to Firebase methods and Siri
    
    func getName() {
        var firstName = ""
        var lastName = ""
        DatabaseService.shared.usersRef.child("\(patientUid!)").child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            firstName = value?["firstName"] as? String ?? ""
            lastName = value?["lastName"] as? String ?? ""
            DispatchQueue.main.async {
                self.patient?.firstName = firstName
                self.patient?.lastName = lastName
                self.nameLabel.text = "\(firstName) \(lastName)"
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sendInformationToFirebase() {
        if let patient = patient {
            DatabaseService.shared.addInfoFromHealthKit(patient: patient)
            createUserActivity()
        }
    }
    
    func createUserActivity() {
        let activity = NSUserActivity(activityType: UserActivityType.sendToServer)
        activity.title = NSLocalizedString("profile.sendToServer", comment: "")
        activity.isEligibleForPrediction = true
        activity.isEligibleForSearch = true
        
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
           sendInformationToFirebase()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailPageVC" {
            let destinationViewController = segue.destination as! PageViewController
            destinationViewController.patient = self.patient
        } else if segue.identifier == "showDoctorsVC" {
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.viewControllers.first as! DoctorsTableViewController
            destination.patient = patient
        }
    }
}
