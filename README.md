<div align="center">

# IT120 | Final Project: Mobile Image Classification App

<p align="center">
  <a href="https://git.io/typing-svg">
    <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&duration=3000&pause=1000&color=2E9EF7&center=true&vCenter=true&width=800&lines=A+mobile+application+built+with+Flutter;Uses+machine+learning+to+classify+snack+chips;Real-time+image+classification+powered+by+TensorFlow+Lite" alt="Typing SVG" />
  </a>
</p>

</div>

---

<div align="center">

## Project Overview

</div>

**Snack-Pack App** is a mobile image classification application built with **Flutter** that leverages **TensorFlow Lite** machine learning to identify and classify **10 different varieties of popular snack chips** in real-time.

The app allows users to scan chip packages using their device camera or select images from their gallery. Once scanned, the trained ML model processes the image and returns a prediction with a confidence score. Results are displayed with detailed analytics including bar graphs and line charts, and can be saved to Firebase for history tracking.

---

<div align="center">

## Application Flow

</div>

```mermaid
graph TB
    Start([User Opens App]) --> Home[Home Page]
    
    Home --> |View Classes| Classes[Class Details Page]
    Home --> |Start Scanning| Scan[Scan Page]
    Home --> |View Records| History[History Page]
    
    Scan --> Camera{Image Source}
    Camera --> |Camera| Capture[Capture New Image]
    Camera --> |Gallery| Gallery[Select from Gallery]
    
    Capture --> Process[Image Processing]
    Gallery --> Process
    
    Process --> ML[TensorFlow Lite Model]
    ML --> |Inference| Predict[Generate Predictions]
    
    Predict --> Result[Result Page]
    Result --> |Display| Analytics[Show Analytics]
    Analytics --> |Confidence Scores| Charts[Bar & Line Charts]
    
    Result --> Save{Save Result?}
    Save --> |Yes| Firebase[Firebase Storage]
    Save --> |No| End1([End Session])
    
    Firebase --> Firestore[(Firestore Database)]
    Firebase --> RealtimeDB[(Realtime Database)]
    
    Firestore --> History
    RealtimeDB --> History
    
    History --> Filter[Apply Filters]
    Filter --> |Category| FilteredResults[Filtered Results]
    
    FilteredResults --> End2([Continue Using App])
    Charts --> End2
    
    Classes --> |Back| Home
    History --> |Back| Home
    Result --> |New Scan| Scan
    
    style Start fill:#4CAF50
    style End1 fill:#F44336
    style End2 fill:#2196F3
    style ML fill:#FF9800
    style Firebase fill:#FFC107
    style Firestore fill:#9C27B0
    style RealtimeDB fill:#9C27B0
```

<details>
<summary><b>View Detailed Workflow Steps</b></summary>

<br>

### User Journey

<table>
<tr>
<td align="center" width="20%">
<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Index%20Pointing%20Up.png" alt="Step 1" width="40" height="40" />
<h4>Step 1</h4>
<b>Launch Application</b><br/>
<sub>User opens the app and navigates to the scan page</sub>
</td>
<td align="center" width="20%">
<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Victory%20Hand.png" alt="Step 2" width="40" height="40" />
<h4>Step 2</h4>
<b>Capture Image</b><br/>
<sub>Take a photo or select from gallery</sub>
</td>
<td align="center" width="20%">
<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/OK%20Hand.png" alt="Step 3" width="40" height="40" />
<h4>Step 3</h4>
<b>Process & Classify</b><br/>
<sub>ML model analyzes the image</sub>
</td>
<td align="center" width="20%">
<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Vulcan%20Salute.png" alt="Step 4" width="40" height="40" />
<h4>Step 4</h4>
<b>View Results</b><br/>
<sub>See predictions with analytics</sub>
</td>
<td align="center" width="20%">
<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Hand%20gestures/Raising%20Hands.png" alt="Step 5" width="40" height="40" />
<h4>Step 5</h4>
<b>Save & Track</b><br/>
<sub>Store results in Firebase for history</sub>
</td>
</tr>
</table>

</details>

---

## Classification Categories

<div align="center">

The application can identify the following **10 chip varieties**:

<table>
<tr>
<td align="center" width="180">
<img src="10-Class-img/Chippy_Chili&Cheese.png" width="100" alt="Chippy Chili & Cheese"/><br/>
<sub><b>Chippy Chili & Cheese</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Clover_Chips_Ham&Cheese.png" width="100" alt="Clover Chips Ham & Cheese"/><br/>
<sub><b>Clover Chips</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Mr._Chips_Corn&Cheese.png" width="100" alt="Mr. Chips Corn & Cheese"/><br/>
<sub><b>Mr. Chips Corn & Cheese</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Nova_Country_Cheddar.png" width="100" alt="Nova Country Cheddar"/><br/>
<sub><b>Nova Country Cheddar</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Oishi_Cracklings_Salt&Vinegar.png" width="100" alt="Oishi Cracklings Salt & Vinegar"/><br/>
<sub><b>Oishi Cracklings</b></sub>
</td>
</tr>
<tr>
<td align="center" width="180">
<img src="10-Class-img/Oishi_Fish_Crackers.png" width="100" alt="Oishi Fish Crackers"/><br/>
<sub><b>Oishi Fish Crackers</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Oishi_Onion_Rings.png" width="100" alt="Oishi Onion Rings"/><br/>
<sub><b>Oishi Onion Rings</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Oishi_Spicy_Seafood_Curls.png" width="100" alt="Oishi Spicy Seafood Curls"/><br/>
<sub><b>Oishi Spicy Seafood Curls</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/Piattos_Cheese.png" width="100" alt="Piattos Cheese"/><br/>
<sub><b>Piattos Cheese</b></sub>
</td>
<td align="center" width="180">
<img src="10-Class-img/V-Cut_Barbecue.png" width="100" alt="V-Cut Barbecue"/><br/>
<sub><b>V-Cut Barbecue</b></sub>
</td>
</tr>
</table>

</div>

---

## Student Information

**Student Name:** Beltran, Michael James

**Course:** IT120 - Integrative Programming and Technologies 2

**Project:** Final Project - Snack Pack Image Classification App

---

<div align="center">

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Camera%20with%20Flash.png" alt="Screenshots" width="30" height="30" /> Application Screenshots

<table>
<tr>
<td align="center">
<b>Home Page</b><br/>
<img src="Snack-Pack-Screenshots/Home-Page.jpg" width="140" alt="Home Page"/>
</td>
<td align="center">
<b>Class Details</b><br/>
<img src="Snack-Pack-Screenshots/Class-Details.jpg" width="140" alt="Class Details"/>
</td>
<td align="center">
<b>Scan Page</b><br/>
<img src="Snack-Pack-Screenshots/Scan-Page.jpg" width="140" alt="Scan Page"/>
</td>
<td align="center">
<b>Scan Result</b><br/>
<img src="Snack-Pack-Screenshots/Classification-Result.jpg" width="140" alt="Classification Result"/>
</td>
<td align="center">
<b>Scan History</b><br/>
<img src="Snack-Pack-Screenshots/Scan-History.jpg" width="140" alt="Scan History"/>
</td>
</tr>
</table>

</div>

---

<div align="center">

## Project Source Code

<table>
<tr>
<td align="center" width="800">
<br/>
<img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="80" height="80" alt="Flutter Code"/>
<br/><br/>
<h3>Snack-Pack-App</h3>
<p><em>Complete Flutter application source code.</em></p>
<br/>
<a href="./Snack-Pack-App/">
<img src="https://img.shields.io/badge/View_Source_Code-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="View Source Code"/>
</a>
<br/><br/>
</td>
</tr>
</table>

</div>

---

<div align="center">

## Related IT120 Course Projects

<table>
<tr>
<td align="center" width="260">
<br/>
<img src="https://raw.githubusercontent.com/gilbarbara/logos/master/logos/tensorflow.svg" width="70" height="70" alt="Final Project"/>
<br/><br/>
<h4>Snack-Pack Classification</h4>
<p><sub>ML model for Snack Pack chip classification.</sub></p>
<br/>
<a href="https://github.com/chael-beltran/Beltran_Snack-Pack-Chips-Varieties_Classification_FinalProject">
<img src="https://img.shields.io/badge/View_Repository-181717?style=for-the-badge&logo=github&logoColor=white" alt="View Repo"/>
</a>
<br/><br/>
</td>
<td align="center" width="260">
<br/>
<img src="https://img.icons8.com/fluency/96/000000/flutter.png" width="70" height="70" alt="Widget Project"/>
<br/><br/>
<h4>Widget Components</h4>
<p><sub>Flutter Widget & UI Design Patterns Activity</sub></p>
<br/>
<a href="https://github.com/chael-beltran/Flutter_Widget_UIComponents.git">
<img src="https://img.shields.io/badge/View_Repository-181717?style=for-the-badge&logo=github&logoColor=white" alt="View Repo"/>
</a>
<br/><br/>
</td>
<td align="center" width="260">
<br/>
<img src="https://img.icons8.com/fluency/96/000000/code.png" width="70" height="70" alt="Activity 1"/>
<br/><br/>
<h4>IT120 Activity 1</h4>
<p><sub>Git & GitHub Activity</sub></p>
<br/>
<a href="https://github.com/chael-beltran/Beltran_IT120_Act1.git">
<img src="https://img.shields.io/badge/View_Repository-181717?style=for-the-badge&logo=github&logoColor=white" alt="View Repo"/>
</a>
<br/><br/>
</td>
</tr>
</table>

</div>

---

<div align="center">

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/People/Technologist.png" alt="Developer" width="30" height="30" /> Developer Profile

<table>
<tr>
<td align="center" width="400">
<br/>
<img src="https://img.icons8.com/fluency/96/000000/github.png" width="80" height="80" alt="GitHub"/>
<br/><br/>
<h3>Connect With Me</h3>
<p><em>Explore more of my projects and contributions</em></p>
<br/>
<a href="https://github.com/chael-beltran">
<img src="https://img.shields.io/badge/Click_here_to_see_my_GitHub_profile-0078D4?style=for-the-badge&logo=github&logoColor=white" alt="GitHub Profile"/>
</a>
<br/><br/>
</td>
</tr>
</table>

</div>

---

<div align="center">

## Technologies Used

<table>
<tr>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="50" height="50" alt="Flutter"/><br/>
<sub><b>Flutter</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="50" height="50" alt="Dart"/><br/>
<sub><b>Dart</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tensorflow/tensorflow-original.svg" width="50" height="50" alt="TensorFlow"/><br/>
<sub><b>TensorFlow Lite</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg" width="50" height="50" alt="Firebase"/><br/>
<sub><b>Firebase</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg" width="50" height="50" alt="Android"/><br/>
<sub><b>Android SDK</b></sub>
</td>
<td align="center" width="120">
<img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Android_Studio_icon_%282023%29.svg" width="50" height="50" alt="Android Studio"/><br/>
<sub><b>Android Studio</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" width="50" height="50" alt="Python"/><br/>
<sub><b>Python</b></sub>
</td>
<td align="center" width="120">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/materialui/materialui-original.svg" width="50" height="50" alt="Material Design"/><br/>
<sub><b>Material Design</b></sub>
</td>
</tr>
</table>

</div>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,14,16,18,20&height=120&section=footer&text=Built%20with%20Flutter%20and%20TensorFlow%20Lite&fontSize=20&fontColor=fff&animation=twinkling&fontAlignY=70&desc=©%202025%20Michael%20James%20Beltran%20|%20IT120%20Final%20Project&descSize=12&descAlignY=88" />

</div>
