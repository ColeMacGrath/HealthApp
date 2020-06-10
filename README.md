# Updating

![alt text](https://user-images.githubusercontent.com/42153044/61584923-01d6df00-ab16-11e9-9811-9b2ece37889a.png)

HealthApp provides a series of tools to provide a better interaction between patients and doctors.
This application is integrated with HealthKit, Firebase and Realm it means that every record of alimentation, sports and more are synchronized between doctor and patient in real time.
In addition incorporates an image analyzer, working in conjunction with automated learning algorithms to predict the presence of different skin lesions with just one photo.

## [Doctor App](https://github.com/ColeMacGrath/HealthApp/tree/Doctor)

| ![alt text](https://user-images.githubusercontent.com/42153044/61669020-42646300-aca4-11e9-913d-cfaec5f3995a.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61612755-05a55700-ac25-11e9-94c7-d0a036becf06.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61612757-05a55700-ac25-11e9-9220-96a1bbbff892.png) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |

## Getting started

### Prerequisites

| Software | **Minimum Version** |     **Recommended**     |
| :------: | :-----------------: | :---------------------: |
|  macOS   | High Sierra 10.13.6 | Mojave 10.14.3 or newer |
|  Xcode   |      Xcode 10       |       Xcode 10.2        |
|  Swift   |      Swift 5.0      |   Swift 5.0 or newer    |
|   iOS    |       iOS 12        |        iOS 12.1         |

### Packages

|        Package         | **Version Tested** |
| :--------------------: | :----------------: |
|        CocaPods        |       1.5.2        |
|        Firebase        |       6.3.0        |
|     Firebase/Auth      |       6.3.0        |
|   Firebase/Database    |       6.3.0        |
|    Firebase/Storage    |       6.3.0        |
|     FloatingPanel      |       1.6.1        |
| IQKeyboardManagerSwift |       6.4.0        |
|    JTAppleCalendar     |       8.0.0        |
|         Charts         |       3.3.0        |
|       RealmSwift       |       3.17.0       |

Podfile included

```
pod 'Charts'
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'FloatingPanel'
pod 'IQKeyboardManagerSwift'
pod 'JTAppleCalendar'
pod 'RealmSwift'
```

### How to Install

1. Clone the project
2. Create a new Pod file from .xcodeproj
3. Install packages listed before
4. Drag and drop [Machine Learning Model](https://1drv.ms/u/s!ArVWVB2r2uzhg-Q90YBJ1-tmu8E0AA?e=19njUT) in HealthApp/Visual Recognizer (Check the Target Membership)
5. Drag and drop your own GoogleService-Info.plist into HealthApp/
6. Activate HealthKit to your Apple ID (Targets -> Capabilities)
7. Activate MapKit to your Apple ID

![alt text](https://user-images.githubusercontent.com/42153044/51432666-ffe0a180-1c00-11e9-9358-e00ee5b00947.png)

## About Trained Model

The model was trained with more than 12,000 images in high resolution

#### Type

Image Classifier

#### Size

66 kb

#### Description

A model trained to determine the pathology of a nevus

#### Model Evaluation Parameters

##### Inputs:

- Image (Color 299x299)

#### Outputs

- classLabelProbs (String -> Double): Probability of each category
- classLabel (String): Most likely image category

## Skin lesion to determine

|        Skin Lesion         | **Number of images for training** | **Original Size** |
| :------------------------: | :-------------------------------: | :---------------: |
|           Nevus            |               8046                |      10.9 GB      |
|          Melanoma          |               2049                |      5.14 GB      |
| Pigmented Benign Keratosis |               1039                |      279 MB       |
|    Basal Cell Carcinoma    |                566                |      606 MB       |
|    Seborrheic Keratosis    |                419                |      1.47 GB      |

## languages

The app was manually translated to

- 🇺🇸 English (US)
- 🇲🇽 Spanish (MX) (not available)
- 🇪🇸 Catalan (ES) (not available)

## Upcoming Features

- macOS Compatibility with project catalyst
- Siri Shortcuts
- Translations

## Some Screenshots

| ![alt text](https://user-images.githubusercontent.com/42153044/61584929-026f7580-ab16-11e9-88cc-b8e788d20cf5.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61584930-026f7580-ab16-11e9-982a-8c8715711bdd.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61584931-026f7580-ab16-11e9-9fb9-fc2b616dba2b.png) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![alt text](https://user-images.githubusercontent.com/42153044/61584928-026f7580-ab16-11e9-8174-5c53a3a6a252.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61584932-03080c00-ab16-11e9-9bb1-99603145ce1c.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61584924-026f7580-ab16-11e9-9f25-0c9eb388b30e.png) |
| ![alt text](https://user-images.githubusercontent.com/42153044/61584927-026f7580-ab16-11e9-8861-a1fcf68904f2.png) | ![alt text](https://user-images.githubusercontent.com/42153044/61584926-026f7580-ab16-11e9-80be-9b6644326c34.png) |                                                              |

![alt text](https://user-images.githubusercontent.com/42153044/61584925-026f7580-ab16-11e9-980a-23e18bfbc306.png)

## Changelog

- Local saving for profile picture
- Added profile picture saved in cloud too
- Added four new skins lesions to determine
- Improved cloud query
- Improved messages error in login and register
- App not crashes on refresh
- Appointments are now working in cloud and local
- Views are improved now are responsive and works in iPhone and iPad
- Added food ingested calories and food name in health types
- Interface redesigned from scratch
- Search Bar for doctor filtering by name

### Comparative table with old and new HealthApp versions

|         Comparison         |       **Original version**       |                       **New version**                        |
| :------------------------: | :------------------------------: | :----------------------------------------------------------: |
|  Original Dataset images   |            170 images            |                        12,119 images                         |
|   Original Dataset size    |             25.9 Mb              |                           18.37 GB                           |
|   Training model options   |         Melanoma & Nevus         | Nevus, Melanoma, Pigmented Benign Keratosis, Basal Cell Carcinoma and Seborrheic Keratosis |
|     Local saving tool      |               None               |                            Realm                             |
|     Cloud saving tool      |             Firebase             |                           Firebase                           |
| iPhone / iPad adaptability | Partilly in iPhone App (patient) |                Full on patient and doctor app                |

## License

MIT

## Acknowledgements

- [ISC](https://www.isic-archive.com/#!/topWithHeader/wideContentTop/main) For main image data set
- [MED-NODE](http://www.cs.rug.nl/~imaging/databases/melanoma_naevi/)
