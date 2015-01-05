runTracker
==========

Create custom interval workouts based on time or distance and track real time workout progress

==========

Running Tracker App

This is an iPhone only app, as there is no reason to expect a user to wish to run with an iPad. The app should however still appear normal on an iPad due to auto layout. 

While not the prettiest app, the UI is still graceful and hopefully intuitive. The app is extremely functional. With a few modifications (filtering the GPS signal being the most important) I could see myself adopting it as my daily running app. It makes extensive use of core data and relationships to keep track of workouts, runs, locations, and intervals. It makes use of MapKit and user location to give real time updates for distance traveled and mapping. It utilizes sounds to give the user cues for their workout so that they do not need to visually consult their device while running, so they may keep their eyes on the path.

 

Features:

The app will track the users movement as they complete workouts. The app allows custom workouts divided into intervals. The user can add, and modify workouts. A log of previous workouts is also kept. Once the user starts running, the app will display stats such as total time, total distance, average pace, current pace, and time and distance for the current interval. 

Audio cues will let the user know when to start the next interval and gives information on the length of the interval and the pace (rest, easy, steady, or fast). The use can also access a map tracking their activity. Once completed, the user can review their workout.

 New features anticipated were Map Kit, Sound System, Location Services, and CategoryViewController. However, category view controller was not used in favor of a table view. AVAudioSystem, specifically AVSpeehSynthesizer was used for speech cues.

Standard features include tab and navigation controllers, NSCoreDataTableViewControllers, and TableViewControllers.

 

Program Flow:

From the main screen (Run Tab) the user can select a workout or go running. The setting feature has not yet been developed would be the first feature to add for future work.

The workout select table view displays all stored workouts. The user can select one of these and will be taken to a detail view of the workout’s intervals. Selecting a workout picks it as the active workout. Selecting an interval or pressing the + interval button segues to the detail interval view, where the user may select the intervals type (time, distance), enter the length in minutes or KM, select the pace, or delete the interval.

The go! button will take the user to a table view which will display total time, total distance, interval time, interval distance, current pace, and average pace. The user can access a map from this screen which uses MapKit to display the user’s progress on a map. A synthesized voice gives updates on the intervals and tells the user that the workout is complete. The app will continue tracking user activity, however, until the Finish Workout button is pressed. This takes the user to a workout summary table view. The view will show the relevant times or distances for each interval. Completed intervals are show in black text, the current interval in blue, and unstarted in red. The user can also access the map from this screen. 

The second tab is for workout history. This table view will display all previous recorded workouts and their date. Clicking on a workout will take the user to a workout summary, identical to the once displayed at the end of the workout. The user can also access the map of the workout from here.

 

Demo:

Due to a known bug, speech synthesis is broken on the iPhone simulator. For this reason, some of the demo must be on the actual device. To most effectively demo the motion tracking portion of the program, it is easier to simulate movement rather than moving with the iPhone (unless you feel like a jog!)

Motion Demo: Run on iPhone 6 simulator and go Debug -> Location -> City Run. On the main screen, the user location should update but leave no breadcrumbs. Once running begins, the distance will update based on movement, as will pace. On the map screen, breadcrumbs will be added as the user travels. 

Synthesized Demo: Run on real device. Create workout with some time intervals (say, 10, 15, and 20 seconds intervals) at any pace. Run this workout. At the appropriate times, the app will announce the start of the next interval, length, and pace. It will also alert with the end of the workout is reached.

 

Future Work:

Filtering the GPS signal to improve accuracy and prevent overestimation of distances. This would require an algorithm to look at input distances fit to a linear-esq path, as we assume the user will run in mostly a straight line or curve, with occasional sharp turns. However, we do not expect the user to jump left and right drastically along a mostly straight path.

Adding settings to control if voice is enable, if distance should be in m, km, or mi, and other options.

Making it possible to delete workout. This functionality is not hard to implement (in fact, it is demonstrated in the interval detail view, where the user can delete intervals). I just couldn’t figure out a nice way to incorporate into the UI and never got around to adding it back in.
