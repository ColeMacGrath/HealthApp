<p align="center">
  <img src="README%20Files/Logo.png" alt="Logo" width="60%">
</p>

![In Progress](https://img.shields.io/badge/status-in%20progress-yellow.svg)

# HealthApp: Next-Generation Health Monitoring

> **HealthApp** brings cutting-edge health monitoring and collaboration with healthcare professionals directly to your fingertips. Our project is actively being developed to transform the management and sharing of health-related data.

Utilizing technologies like HealthKit, CoreML, and ChatGPT, HealthApp offers a comprehensive suite of tools for personal health management and professional healthcare collaboration.

## Some screenshots

<table>
  <tr>
    <td align="center"><img src="README Files/Dashboard.png" alt="Dashboard" width="200"/><br>Dashboard</td>
    <td align="center"><img src="README Files/Profile.png" alt="Profile" width="200"/><br>Profile</td>
    <td align="center"><img src="README Files/My Doctors.png" alt="My Doctors" width="200"/><br>My Doctors</td>
    <td align="center"><img src="README Files/Doctor Profile.png" alt="Doctor Profile" width="200"/><br>Doctor Profile</td>
  </tr>
  <tr>
    <td align="center"><img src="README Files/Appointment.png" alt="Appointment" width="200"/><br>Appointment</td>
    <td align="center"><img src="README Files/Appointments.png" alt="Appointments" width="200"/><br>Appointments</td>
    <td align="center"><img src="README Files/Created Appointment.png" alt="Created Appointment" width="200"/><br>Created Appointment</td>
    <td align="center"><img src="README Files/Fitzpatrick Explanation.png" alt="Fitzpatrick Explanation" width="200"/><br>Fitzpatrick Explanation</td>
  </tr>
  <tr>
    <td align="center"><img src="README Files/Fitzpatrick Scan.png" alt="Fitzpatrick Scan" width="200"/><br>Fitzpatrick Scan</td>
    <td align="center"><img src="README Files/Fitzpatrick.png" alt="Fitzpatrick" width="200"/><br>Fitzpatrick</td>
    <td align="center"><img src="README Files/Nevus.png" alt="Nevus" width="200"/><br>Nevus</td>
    <td align="center"><img src="README Files/History.png" alt="History" width="200"/><br>History</td>
  </tr>
  <tr>
    <td align="center"><img src="README Files/Sleep.png" alt="Sleep" width="200"/><br>Sleep</td>
    <td align="center"><img src="README Files/QR.png" alt="QR" width="200"/><br>QR</td>
  </tr>
</table>

## Key Features ✨

- **HealthKit Integration:** Seamlessly retrieve health metrics from HealthKit to monitor your well-being. Perfect for keeping a close eye on vital statistics.
- **Doctor Collaboration:** Add doctors, schedule appointments, and share health data securely. Using QR codes, sharing information is both safe and simple.
- **Skin Issue Detection:** Utilize advanced CoreML models to identify skin issues, such as melanomas, through a simple camera snap. Early detection is key to effective treatment.
- **Fitzpatrick Scale Detection:** Determine your skin type with ease using our specialized CoreML Model for accurate skincare recommendations.
- **Comprehensive Dashboards:** Easily access your health metrics, including BPM, sleep hours, and more, presented in a user-friendly interface.
- **Mocking Support:** With fully mocked interactions using Proxyman, ensure a robust testing environment that mimics real-world application use.

## Getting Started 🚀

### Prerequisites

- **Xcode 15** or newer
- An **iPhone** or **iPad** running **iOS 17** or newer

### Setup

1. **Clone the repository** to your local machine:
   ```bash
   git clone https://github.com/ColeMacGrath/HealthApp.git

2. **Navigate** to `HealthApp/Utilities/keys.plist` and configure your OpenAI key:

   ```plist
   <key>openAIKey</key>
   <string>YourKeyValueHere</string>
   ```

   To obtain an OpenAI key, visit [OpenAI API](https://openai.com/api/).

### Installation

1. Open `HealthApp.xcodeproj` in Xcode.
2. Build the project for your target device.
3. Run the app on your device or an emulator to begin exploring its features.

## How to Use 📲

- **Dashboard and Profile:** Get an overview of your health status and manage your personal profile.
- **Doctors and Appointments:** Easily add doctors to your network and schedule appointments.
- **Skin Health:** Use the nevus analyzer to detect potential skin issues early.
- **Sleep and Activity Tracking:** Monitor and analyze your sleep patterns and daily activities for better health management.

## Contributing

We welcome contributions from the community! If you'd like to contribute, please:

1. Fork the repository.
2. Create a new branch for your feature.
3. Add or improve features.
4. Submit a pull request.

## Mocking With Proxyman ![Coming Soon](https://img.shields.io/badge/coming-soon-red.svg)

### Test HealthApp with Simulated Data:

1. Install Proxyman on your Mac.
2. Configure Proxyman to route HealthApp's network traffic:
   - Use the local URL: `https://api.healthapp.local/`

Detailed configuration for routes and endpoints can be found in `HealthApp/Models/Shared/RequestManager.swift`.

| Script Name        | Matching Rule                                     | Type     | Method |
| ------------------ | ------------------------------------------------- | -------- | ------ |
| Book Appointment   | https://api.healthapp.local/bookAppointment       | Wildcard | POST   |
| Delete Appointment | https:\/\/api\.healthapp\.local\/.*\/appointment  | Regex    | DELETE |
| Appointment List   | https://api.healthapp.local/doctors               | Wildcard | GET    |
| Add Doctor         | https:\/\/api\.healthapp\.local\/.*\/appointments | Regex    | PATCH  |
| Delete Doctor      | https://api.healthapp.local/doctors               | Wildcard | DELETE |
| Doctors List       | https:\/\/api\.healthapp\.local\/.*\/doctors      | Regex    | GET    |
| Patients List      | https:\/\/api\.healthapp\.local\/.*\/patients     | Regex    | GET    |