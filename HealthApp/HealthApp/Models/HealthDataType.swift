//
//  HealthDataType.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import RealmSwift

class HearthRecord: Object {
    @objc private(set) dynamic var _bpm: Int = 0
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    
    convenience init(bpm: Int, startDate: Date, endDate: Date) {
        self.init()
        self._bpm = bpm
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var bpm:        Int  { return _bpm       }
    var startDate:  Date { return _startDate }
    var endDate:    Date { return _endDate   }
    
}

class WorkoutRecord: Object {
    @objc private(set) dynamic var _type: String = ""
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    @objc private(set) dynamic var _caloriesBurned: Double = 0.0
    
    convenience init(startDate: Date, endDate: Date, caloriesBurned: Double) {
        self.init()
        self._startDate = startDate
        self._endDate = endDate
        self._caloriesBurned = caloriesBurned
    }
    
    var time:       String { return _endDate.offsetFrom(date: _startDate, dateTerm: .short) }
    var calories:   Double { return _caloriesBurned }
    var startDate:  Date   { return _startDate }
    var endDate:    Date   { return _endDate }
    
}

class SleepAnalisys: Object {
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    
    convenience init(startDate: Date, endDate: Date) {
        self.init()
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var hoursSleeping:  String { return _endDate.offsetFrom(date: _startDate, dateTerm: .short) }
    var startDate:      Date   { return _startDate }
    var hoursElapsed:   Int    { return _endDate.hoursElapsed(date: _startDate) }
}

class Height: Object {
    @objc private(set) dynamic var _height: Double = 0.0
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    
    convenience init(height: Double, startDate: Date, endDate: Date) {
        self.init()
        self._height = height
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var height: Double  { return _height }
    var startDate: Date { return _startDate }
}

class Weight: Object {
    @objc private(set) dynamic var _weight: Double = 0.0
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    
    convenience init(weight: Double, startDate: Date, endDate: Date) {
        self.init()
        self._weight = weight
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var weight:     Double { return _weight }
    var startDate:  Date   { return _startDate }
}

class StepRecord: Object {
    @objc private(set) dynamic var _steps: Int = 0
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    
    convenience init(steps: Int, startDate: Date, endDate: Date) {
        self.init()
        self._steps = steps
        self._startDate = startDate
        self._endDate = endDate
    }
    
    var steps:   Int  { return _steps }
    var endDate: Date { return _endDate }
}


class BasicRecord {
    private var _record = ""
    private var _date = ""
    private var _data: Double
    
    init(record: String, date: String, data: Double) {
        _record = record
        _date = date
        _data = data
    }
    
    var record: String { return _record  }
    var date:   String { return _date    }
    var data:   Double { return _data    }
}
