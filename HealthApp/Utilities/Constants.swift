//
//  Constants.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 28/12/23.
//

import Foundation

struct Constants {
    struct Segues {
        static let showLoginViewController = "ShowLoginVC"
        static let showSplitViewController = "ShowSplitViewController"
        static let showEditProfileViewController = "ShowEditProfileVC"
        static let showDoctorProfileVC = "ShowDoctorProfileVC"
        static let showAppointmentVC = "ShowAppointmentVC"
        static let showBookAppointmentVC = "ShowBookAppointmentVC"
        static let showHistoryVC = "ShowHistoryVC"
        static let showFilterVC = "ShowFilterVC"
        static let showCaloriesSummaryViewController = "ShowCaloriesSummaryVC"
        static let showRecommendationViewController = "ShowRecommendationVC"
        static let showFitzpatrickView = "ShowFitzpatrickView"
        static let showPermissionsViewController = "ShowPermissionsVC"
        static let showSleepHistoryVC = "ShowSleepHistoryVC"
        static let showPatientProfileVC = "ShowPatientProfileVC"
        static let showPatientsVC = "ShowPatientsVC"
        static let showSchedulesVC = "ShowSchedulesVC"
        static let showEditProfileVC = "ShowEditProfileVC"
    }
    
    struct Cells {
        static let labelIconCell = "LabelIconCell"
        static let textFieldCell = "TextFieldCell"
        static let labelButtonCell = "LabelButtonCell"
        static let imageCell = "ImageCell"
        static let appointmentCell = "AppointmentCell"
        static let basicCell = "BasicCell"
        static let collectionViewTableViewCell = "CollectionViewTableViewCell"
        static let dataTableViewCell = "DataTableViewCell"
        static let profileImageCell = "ProfileImageCell"
        static let buttonCell = "ButtonCell"
        static let datePickerCell = "DatePickerCell"
        static let dateTimeCell = "DateTimeCell"
        static let inlineDatePicker = "InlineDatePicker"
        static let textViewCell = "TextViewCell"
        static let historyRecordCell = "HistioryRecordVC"
        static let colorCell = "ColorCell"
        static let profileHorizontalCell = "ProfileHorizontalCell"
        static let statusCell = "StatusCell"
        static let dualSelectionCell = "DualSelectionCell"
        static let scheduleCell = "ScheduleCell"
        //CollectionView
        static let profileCell = "ProfileCell"
        static let dashboardDataCell = "DashboarDataCell"
        static let doctorCell = "DoctorCell"
        static let dataCell = "DataCell"
        static let pictureNameCell = "PictureNameCell"
        static let detailCell = "DetailCell"
        static let singleLabelCell = "SingleLabelCell"
    }
    
    struct SFSymbols {
        static let person = "person"
        static let personFill = "person.fill"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let calendar = "calendar"
    }
    
    struct Storyboard {
        static let main = "Main"
        static let tabBar = "TabBar"
        static let dashboard = "Dashboard"
        static let doctors = "Doctors"
        static let appointments = "Appointments"
        static let doctorDashboard = "DoctorDashboard"
        static let doctorSettings = "DoctorSettings"
        static let patientProfile = "PatientProfile"
    }
    
    struct ViewIdentifiers {
        static let initialViewController = "InitialViewController"
        static let loginViewController = "LoginViewController"
        static let primaryTableViewController = "PrimaryTableViewController"
        static let tabBarViewController = "TabBarController"
        static let dashboardNavigationController = "DashboardNC"
        static let doctorsNC = "DoctorsNC"
        static let appointmentsNC = "AppointmentsNC"
        static let addDoctorVC = "AddDoctorVC"
        static let authenticationVC = "AuthenticationVC"
        static let doctorDashboardNC = "DoctorDashboardNC"
        static let doctorsSettingsVC = "DoctorSettingsVC"
        static let patientProfileVC = "PatientProfileVC"
    }
}
