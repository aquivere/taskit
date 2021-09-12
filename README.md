# Taskit ![Taskit_logo](https://user-images.githubusercontent.com/86246033/132982597-3066244e-33cc-43ed-bf0f-3c1c363dbbda.png)

Taskit is an IOS application using where you can store regular tasks and to-do items, as well as regularly repeating tasks, and be able to check them off when completed. Regular tasks will have the option to have notifications, and be automatically deleted when completed, while repeating tasks reset to become incomplete when the next time period has passed. 

This application was built using Swift and SwiftUI.

## ⚙️ General Use
This application provides a quick intro when first using it, and prompts users to input their name.
<br /> 

https://user-images.githubusercontent.com/79503993/132985856-96ca81c9-de40-4c27-9b31-be0a640dd118.mp4 

<br />
There are then two lists shown - one for regular one-time tasks, and the other for regular repeated tasks (i.e. weekly, fortnightly or monthly). When regular tasks are ticked off, they fade away and disappear, whereas when recurring tasks are ticked off, they disappear for the time being until they are to be completed again.  <br /> 

https://user-images.githubusercontent.com/79503993/132985992-070cc38e-63e6-48e2-a45a-a371c9c8e639.mp4

 <br />
There is also the option to allow notifications for regular tasks  
<br /> 


https://user-images.githubusercontent.com/79503993/132986082-38398ad9-32bc-4b81-a0a2-0e9ada79d62f.mp4


<br />
If allowed, notifications will show if you have not completed the task by the due time. 
<br /> 


https://user-images.githubusercontent.com/79503993/132986392-172983c2-941a-454f-a278-2ab525c3a4f4.mp4


<br />
The three time periods - weekly, fortnightly and monthly - each have lists which can be viewed by long pressing on the list title, and then switching between them.  <br /> 

https://user-images.githubusercontent.com/79503993/132985893-a0eca176-3f01-4379-b5e0-c598543d22a8.mp4

 <br />
Additional features include settings to toggle between light and dark mode within the app, having the app personalised with your name, and the number of regular tasks being provided on the screen.  <br /> [INSERT VIDEO CLIP] <br />

## 🚀 Launch
This application is not currently published on the Apple App Store. <br/> 
To run it, please follow these instructions:
1. Git clone this repo and open it in Xcode. 
2. Run the program through the Xcode simulator, which will simulate how the app performs on a phone.

To run it on a phone, a Macbook with Xcode, and an iPhone are required. There is a chance of issues occurring during the process, which will prevent it from being launched on a phone, due to the bundle identifier and the signing & capabilities. However, if you wish to proceed, please follow these instructions:
1. Git clone this repo and open it in Xcode. In ToDoList's "Signing & Capabilities", you may need to change your team to your own Apple account.
2. Connect iPhone to laptop through USB.
3. In the Product tab, choose Destination and set it to your iPhone. 
4. Run the code to launch the app on your iPhone.
5. In your iPhone settings, head to General > Device Management > Apple Development and click Trust to allow the app to be run on your phone.
6. The app should now be available to be used on your phone! Please note that this build will only last for 7 days on your phone.
