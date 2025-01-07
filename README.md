# Focus Friend

Focus Friend is an iOS application designed to help high school students overcome procrastination and stay focused on their studies. By providing personalized study routines, helpful study pointers, and detailed analytics, Focus Friend aims to make study sessions more efficient and engaging.

---

## Table of Contents

1. [Our Story](#our-story)  
2. [Our Vision](#our-vision)  
3. [Key Features](#key-features)  
   - [Personalized Study Routine](#personalized-study-routine)  
   - [Study Habits & Tips](#study-habits--tips)  
   - [Analytics](#analytics)  
4. [File Structure](#file-structure)  
   - [Study Flow](#study-flow)  
   - [Analytics & Tracking](#analytics--tracking)  
   - [UI Components & Cells](#ui-components--cells)  
   - [Core App & Utilities](#core-app--utilities)  
   - [Additional Features](#additional-features)  
5. [Resources & Links](#resources--links)

---

## Our Story

Throughout high school, many students struggle with procrastination. Whether it’s scrolling through social media or hopping on FaceTime, it’s easy to avoid difficult tasks until the last minute. We built **Focus Friend** to address this common challenge: to help students manage their workloads, take organized breaks, and ultimately enhance productivity.

---

## Our Vision

Our vision is simple yet impactful: **Help every high schooler focus and stop procrastinating.** By cultivating better study habits and offering personalized tips, Focus Friend aspires to provide an all-in-one toolkit for academic success.

---

## Key Features

### Personalized Study Routine
- **Tailor-made Intervals**: Configure your study and break durations for each subject.  
- **Adaptive Scheduling**: As you use Focus Friend, the app nudges you to adjust intervals for optimal productivity.  

### Study Habits & Tips
- **Customized Strategies**: Based on your preferences and responses to short questions, Focus Friend provides strategies like breathing exercises, background music playlists, and fidget tool suggestions.  
- **Anxiety-Relief Methods**: Learn techniques to stay calm and maintain focus during intense study sessions.  

### Analytics
- **Study Statistics**: Track total time studied, total breaks taken, and total study intervals per subject.  
- **Reflection & Improvement**: Identify areas to improve by reviewing your usage patterns.  

---

## File Structure

Below is an overview of the primary files and folders in the **Focus Friend** project. This is our best guess as to each file’s purpose based on naming and context:

### Study Flow
- **ChooseSubjectForStudy.swift** – Screen or logic for choosing which subject to study.  
- **ChooseTaskForStudy.swift** – Screen or logic for choosing a specific task under a subject.  
- **ConfirmStudyIntervals.swift** – Confirms the user’s chosen study/break durations.  
- **OfficialTimer.swift** – Manages the timer logic for study and break sessions.  
- **OfficialBreak.swift** – Screen or logic handling the break state.  
- **UpdateStudyIntervals.swift** – Updates user’s chosen intervals after confirming or making changes.  
- **StudyFeature.swift / StudyFeatureTwo.swift** – Core logic driving the study session features (e.g., start, pause, end sessions).  
- **StudyFeatureTwo.xib** – UI layout for the second study feature screen (if separate from the main study UI).  
- **TasksDetails2.swift** – Possibly a second-level detail view for tasks.  
- **TaskDetails1.swift / TaskDetails1Cell.swift / TaskDetails1Cell.xib** – First-level detail view and custom cells for tasks.  
- **TaskCell.swift / TaskCell.xib** – Custom table view cell for displaying individual tasks.  

### Analytics & Tracking
- **AnalyticsFeature.swift** – Main logic for analytics, handling data tracking, calculations, and display.  
- **AnalyticsCell.swift / AnalyticsCell.xib** – Custom table view cell for showing analytics data in a list.  
- **viewAnalytics.swift** – Screen that presents the analytics to the user.  
- **LifetimeStats.swift** – Likely displays total usage stats across the entire lifetime of the user’s study sessions.

### UI Components & Cells
- **FriendCell.swift / FriendCell.xib** – Custom cell for displaying friends or social connections in the app.  
- **FidgetTool.swift / FidgetTool.xib** – Manages a fidget tool feature (e.g., UI element that simulates a fidget spinner or clickable tool).  
- **Meditate.swift / Meditate.xib** – Screen guiding users through quick meditation or breathing exercises.  
- **Congratulations.swift** – Screen to display after successfully completing a study session.  
- **Thanks.swift** – Possibly a short “thank you” or completion screen.  

### Core App & Utilities
- **AppDelegate.swift** – Standard iOS entry point for app-level configurations.  
- **SceneDelegate.swift** – Standard iOS scene management.  
- **Info.plist** – iOS property list containing app configuration values (permissions, settings, etc.).  
- **Private Certificate.p12** – Likely a push notification or distribution certificate.  
- **Settings.swift** – Allows user to configure or modify app settings.  
- **AddSubjectinSettings.swift** – Manages adding new subjects from the Settings screen.  
- **Reminder.swift** – Likely sets or manages local reminders/notifications.

### Additional Features
- **CustomLogIn.swift / CustomSignUp.swift** – Implement custom login and sign-up screens for user authentication.  
- **SocialFeature.swift** – Possibly logic for social interactions, maybe adding friends or sharing progress.  
- **addFriends.swift** – Allows user to add friends within the app.  
- **TipsFeature.swift** – Provides study or app usage tips.  
- **TO ADMISSIONS OFFICERS** – A document or screen dedicated to college admissions officers (possibly an informational letter).  

---

## Resources & Links

- **Official Website**:  
  [https://focusfriend01.wixsite.com/focus-friend](https://focusfriend01.wixsite.com/focus-friend)  
- **Terms of Use**:  
  [https://focusfriend01.wixsite.com/focus-friend/terms-and-conditions-1](https://focusfriend01.wixsite.com/focus-friend/terms-and-conditions-1)  
- **Privacy Policy**:  
  [https://focusfriend01.wixsite.com/focus-friend/privacy-policy](https://focusfriend01.wixsite.com/focus-friend/privacy-policy)  

---

Thank you for your interest in **Focus Friend**. We hope that this app will help students stay on track, minimize distractions, and achieve their study goals. For any questions or contributions, please feel free to reach out via our [official website](https://focusfriend01.wixsite.com/focus-friend).

Happy Studying!

— The Focus Friend Team
