import Foundation

struct HearthRecord {
    private var _bpm: Int
    private var _starDate: Date
    private var _endDate: Date
    
    init(bpm: Int, startDate: Date, endDate: Date) {
        _bpm = bpm
        _starDate = startDate
        _endDate = endDate
    }
    
    var bpm:        Int  { return _bpm }
    var startDate:  Date { return _starDate }
    var endDate:    Date { return _endDate }
}

struct WorkoutRecord {
    private var _type: String
    private var _startDate: Date
    private var _endDate: Date
    private var _caloriesBurned: Double
    
    init(startDate: Date, endDate: Date, caloriesBurned: Double) {
        _startDate = startDate
        _endDate = endDate
        _caloriesBurned = caloriesBurned
        _type = ""
    }
    
    var time:       String { return _endDate.offsetFrom(date: _startDate) }
    var calories:   Double { return _caloriesBurned }
    var startDate:  Date   { return _startDate }
    var endDate:    Date   { return _endDate }
}

struct SleepAnalisys {
    private var _startDate: Date
    private var _endDate: Date
    
    init(startDate: Date, endDate: Date) {
        _startDate = startDate
        _endDate = endDate
    }
    
    var hoursSleeping:  String { return _endDate.offsetFrom(date: _startDate) }
    var startDate:      Date   {  return _startDate }
}

struct Height {
    private var _height: Double
    private var _startDate: Date
    private var _endDate: Date
    
    init(height: Double, startDate: Date, endDate: Date) {
        _height = height
        _startDate = startDate
        _endDate = endDate
    }
    
    var height: Double { return _height }
    var startDate: Date { return _startDate }
}

struct Weight {
    private var _weight: Double
    private var _startDate: Date
    private var _endDate: Date
    
    init(weight: Double, startDate: Date, endDate: Date) {
        _weight = weight
        _startDate = startDate
        _endDate = endDate
    }
    
    var weight:     Double { return _weight }
    var startDate:  Date   { return _startDate }
}

struct StepRecord {
    private var _steps: Int
    private var _startDate: Date
    private var _endDate: Date
    
    init(steps: Int, startDate: Date, endDate: Date) {
        _steps = steps
        _startDate = startDate
        _endDate = endDate
    }
    
    var steps:   Int  { return _steps }
    var endDate: Date { return _endDate }
}
