//
//  Appointment.swift
//  HealthApp
//
//  Created by Moisés Córdova on 7/9/19.
//  Copyright © 2019 Moisés Córdova. All rights reserved.
//

import Foundation
import EventKit
import RealmSwift

class Appointment: Object {
    @objc private(set) dynamic var _startDate: Date = Date()
    @objc private(set) dynamic var _endDate: Date = Date()
    @objc private(set) dynamic var _doctorUid: String = ""
    @objc private(set) dynamic var _patientUid: String = ""
    @objc private(set) dynamic var _notes: String?
    @objc private(set) dynamic var _id: String = ""
    @objc private(set) dynamic var _patientLocalIdentifier: String?
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(startDate: Date, endDate: Date, doctorUid: String, patientUid: String, notes: String?) {
        self.init()
        _startDate = startDate
        _endDate = endDate
        _doctorUid = doctorUid
        _patientUid = patientUid
        _notes = notes
        _id = "\(startDate)-\(doctorUid)-\(patientUid)"
    }
    
    var doctorUid:  String { return _doctorUid }
    var id:         String { return _id }
    var patientUid: String { return _patientUid }
    var startDate:  Date { return _startDate }
    var endDate:    Date { return _endDate }
    
    var localIdentifier: String? {
        set {
            _patientLocalIdentifier = newValue
        }
        get {
            return _patientLocalIdentifier
        }
    }
    
    var notes: String? {
        set {
            _notes = newValue
        }
        get {
            return _notes
        }
    }
    
    var duration: String {
        return "1 Hour"
    }
    
    func sendToServer() {
        DatabaseService.shared.create(appointment: self)
    }
    
    /*func totalRemoveFromServer() {
        DatabaseService.shared.totalRemove(appointment: self)
    }
    
    func removeFromServer() {
        DatabaseService.shared.remove(appointment: self)
    }*/
    
    func removeFromLocalCalendar() -> Bool {
        var removed = true
        let eventStore: EKEventStore = EKEventStore()
        let eventToRemove = eventStore.event(withIdentifier: self.localIdentifier!)
        do {
            if eventToRemove != nil {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            }
        } catch {
            removed = false
        }
        
        return removed
    }
    
    func removeFromFirebase(appointmentUID: String, patientUID: String, doctorUID: String) {
        DatabaseService.shared.remove(appointmentUID: appointmentUID, patientUID: patientUID, doctorUID: doctorUID)
    }
    
    func createInCalendar(doctor: Doctor) -> String? {
        var messageInfo: String?
        let eventStore: EKEventStore = EKEventStore()
        let title = "Medical appointment with the \(doctor.specialty) \(doctor.firstName) \(doctor.lastName)"
        let startDate = self.startDate
        let endDate = self.endDate
        let notes = self.notes
        let location = doctor.direction
        self.sendToServer()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = notes
                event.location = location
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    messageInfo = event.eventIdentifier
                } catch let error as NSError {
                    messageInfo = NSLocalizedString("createAppointment.localError", comment: "")
                    //_ = self.removeFromServer()
                    print("ERROR => \(error)")
                }
            } else {
                messageInfo = NSLocalizedString("errorInfo.accesNotGranted", comment: "")
            }
        }
        return messageInfo
    }
    
}

