# Flutter Shop App Sample

A Flutter app developed to train the implementation of features described on Features section. The app is using backend as a service provided by Firebase.

## Project Status

This project is just a personal showcase, done with de aim of  register what i have studied, and show my skills. It may receives improvements in the future.

## Features in this project

 - [x] Custom authentication with email via Firebase
 - [x] Form validation
 - [x] State management with Provider
 - [x] NoSQL database with Firebase Real Time Database
 - [x] Authentication Token generation
 - [x] Automatic sign in
 - [x] Automatic logout when Token expires
 - [x] Custom transitions with PageTransitionsBuilder
 - [x] Add and remove items from the cart
 - [x] Insert, update and remove products on Firebase Real Time database
 - [x] List of orders from each user
 - [x] Product grid
 - [x] Product details screen


## Project features preview

| Register and login                                     | Logout                                         |
| ------------------------------------------------------ | ---------------------------------------------- |
| ![](assets/images/captures/1%20-%20login_register.gif) | ![](assets/images/captures/7%20-%20logout.gif) |

##

| User favorites                                         | Cart                                         |
| ------------------------------------------------------ | -------------------------------------------- |
| ![](assets/images/captures/3%20-%20user_favorites.gif) | ![](assets/images/captures/4%20-%20cart.gif) |

##

| Making orders                                         |
| ----------------------------------------------------- |
| ![](assets/images/captures/5%20-%20making_orders.gif) |

##
| Inserting products                                       | Product details                                              |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| ![](assets/images/captures/6%20-%20insert%20product.gif) | ![](assets/images/captures/2%20-%20home_product_details.gif) |


## Installation and Setup Instructions

Clone down this repository. You will need `Flutter` and `Dart` installed globally on your machine.

Installation:

`flutter pub get install` on the project root.

To Run the android application:

`flutter run -d <device or emulator id>`

To build a android release:

`flutter build apk` the package will be generated on **./build/app/outputs/flutter-apk/app-release.apk**

