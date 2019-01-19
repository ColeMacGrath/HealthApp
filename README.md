![alt text](https://user-images.githubusercontent.com/42153044/51432658-cb6ce580-1c00-11e9-9593-efea6e7cc575.png)

HealthApp provides a series of tools to provide a better interaction between patients and doctors.
This application is integrated with HealthKit and Firebase, it means that every record of alimentation, sports and more are synchronized between doctor and patient in real time.
In addition incorporates an image analyzer, working in conjunction with automated learning algorithms to predict the presence of melanomas with just one photo.

## Getting started

### Prerequisites

* macOS
* Xcode
* Swift 4
* iOS 12

### Packages

* CocoaPods
* Firebase/Core
* Firebase
* Firebase/Storage
* Firebase/Database
* Firebase/Auth
* SCLAlertView (Optional)
* IQKeyboardManagerSwift (Optional)

### How to Install

1. Clone the project
2. Create a new Pod file from .xcodeproj
3. Install packages listed before
4. Drag and drop [Machine Learning Model](google.com) in HealthApp/Visual Recognizer (Check the Target Membership)
5. Drag and drop your own GoogleService-Info.plist into HealthApp/
6. Activate HealthKit to your Apple ID (Targets -> Capabilities)
7. Activate MapKit to your Apple ID

![alt text](https://user-images.githubusercontent.com/42153044/51432666-ffe0a180-1c00-11e9-9358-e00ee5b00947.png)

## Screenshots

## About Trained Model

The model was trained with more than 3,000 images in high resolution

#### Type

Image Classifier

#### Size

20 kb

#### Description

A model trained to determine the pathology of a naevus

#### Model Evaluation Parameters

##### Inputs:

* Image (Color 299x299)

#### Outputs

* classLabelProbs (String -> Double): Probability of each category
* classLabel (String): Most likely image category

## languages
The app was manually translated to
* 🇺🇸 English (US)
* 🇲🇽 Spanish (MX)
* 🇪🇸 Catalan (ES)
* 🇫🇷 French (FR) (Beta)

## Some Screenshots
![alt text](https://user-images.githubusercontent.com/42153044/51432782-18ea5200-1c03-11e9-82f8-81e0c76a3d3b.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432783-18ea5200-1c03-11e9-85a3-1d437f152890.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432784-1982e880-1c03-11e9-9f50-01975056499f.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432785-1982e880-1c03-11e9-94aa-81990b9da442.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432786-1982e880-1c03-11e9-9842-b16285301bb5.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432787-1982e880-1c03-11e9-8d4e-7a03b4b10608.png)
![alt text](https://user-images.githubusercontent.com/42153044/51432788-1a1b7f00-1c03-11e9-9edd-537b06b6bc3b.png)

## License
MIT

## Acknowledgements

* [ISC](https://www.isic-archive.com/#!/topWithHeader/wideContentTop/main) For main image data set
* [MED-NODE](http://www.cs.rug.nl/~imaging/databases/melanoma_naevi/)
