<p align="center">
  <img src="README%20Files/Logo.png" alt="Logo" width="60%">
</p>

![In Progress](https://img.shields.io/badge/status-in%20progress-yellow)

> Bringing cutting-edge health monitoring and doctor collaboration to your fingertips. **Currently in Progress**

HealthApp is an innovative application designed to revolutionize the way we track, analyze, and share health-related data. By harnessing the power of HealthKit, CoreML, and ChatGPT, HealthApp provides a comprehensive suite of tools for personal health management and professional healthcare collaboration.

## Some Screenshots

<table>
  <tr>
    <td align="center">
      <img src="README Files/Dashboard.png" alt="Dashboard" width="200"/><br>
      Dashboard
    </td>
    <td align="center">
      <img src="README Files/Profile.png" alt="Profile" width="200"/><br>
      Profile
    </td>
    <td align="center">
      <img src="README Files/My Doctors.png" alt="My Doctors" width="200"/><br>
      My Doctors
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="README Files/Appointment.png" alt="Appointment" width="200"/><br>
      Appointment
    </td>
    <td align="center">
      <img src="README Files/Appointments.png" alt="Appointments" width="200"/><br>
      Appointments
    </td>
    <td align="center">
      <img src="README Files/Created Appointment.png" alt="Created Appointment" width="200"/><br>
      Created Appointment
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="README Files/Fitzpatrick Explanation.png" alt="Fitzpatrick Explanation" width="200"/><br>
      Fitzpatrick Explanation
    </td>
    <td align="center">
      <img src="README Files/Fitzpatrick Scan.png" alt="Fitzpatrick Scan" width="200"/><br>
      Fitzpatrick Scan
    </td>
    <td align="center">
      <img src="README Files/Fitzpatrick.png" alt="Fitzpatrick" width="200"/><br>
      Fitzpatrick
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="README Files/Nevus.png" alt="Nevus" width="200"/><br>
      Nevus
    </td>
    <td align="center">
      <img src="README Files/History.png" alt="History" width="200"/><br>
      History
    </td>
    <td align="center">
      <img src="README Files/Sleep.png" alt="Sleep" width="200"/><br>
      Sleep
    </td>
  </tr>
  <tr>
    <td align="center" colspan="3">
      <img src="README Files/QR.png" alt="QR" width="200"/><br>
      QR
    </td>
  </tr>
</table>

## Features ✨

- **HealthKit Integration:** Seamlessly retrieve health metrics directly from HealthKit to monitor your well-being.
- **Doctor Collaboration:** Add doctors, schedule appointments, and share health data securely through QR codes.
- **Skin Issue Detection:** Utilize advanced CoreML models for detecting skin issues like melanomas with just a camera snap.
- **Fitzpatrick Scale Detection:** Determine your skin type using a photo, thanks to our trained CoreML Model.
- **Comprehensive Dashboards:** View your health metrics, including BPM, sleep hours, and more, in an easy-to-understand format.
- **Mocking Support:** Fully mocked interactions with Proxyman for a robust testing environment.

## Getting Started 🚀

### Prerequisites

- Xcode 15 or later
- An iPhone or iPad running iOS 17 or later

### Setup

1. Clone the repository to your local machine.

2. Navigate to 

   ```
   HealthApp/Utilities/keys.plist
   ```

    and insert your OpenAI key as follows:

   - Key: `openAIKey`
   - Value: `YourKeyValueHere`

### Installation

1. Open `HealthApp.xcodeproj` in Xcode.
2. Build the project for your target device.
3. Run the app on your device or an emulator.

### How to Use 📲

1. **Dashboard and Profile:** Get an overview of your health status and manage your profile.
2. **Doctor and Appointments:** Add doctors and schedule appointments through the app.
3. **Skin Health:** Use the nevus analyzer view to detect potential skin issues.
4. **Sleep and Activity Tracking:** Monitor sleep hours and other health metrics for comprehensive health management.

## Mocking With Proxyman ![In Progress](https://img.shields.io/badge/coming-soon)

To test HealthApp with simulated data:

1. Install Proxyman on your Mac.
2. Configure Proxyman to route HealthApp's network traffic through it.
3. Use the provided mocking rules to simulate various data scenarios.