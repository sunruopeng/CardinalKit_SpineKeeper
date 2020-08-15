# SpineKeeper_Update

The main Xcode project file is ORKSample/OrkSample.xcodeproj

There are two external frameworks used: Researchkit and Carekit. The Researchkit version is at https://github.com/sunruopeng/ResearchKit and the Carekit version is at https://github.com/sunruopeng/ResearchKit. For both repositories, use the ``stanfordback`` branch.

the current code can run on Xcode 10.2.1 as well as 11.5.


Junaid's Work
=============

June 26, 2020
----------------
* Creates private fork of ResearchKit
* Creates private fork of CareKit
* Syncs custom code changes of ResearchKit into the latest code of ResearchKit
* Upgrades the current codebase (SpineKeeper) with latest version of ResearchKit 2.1
* Fixes deprecated methods with new implementations
* Fixes warnings in the codebase
* Upgrades the project file to support the latest version of ResearchKit
* Fixes spelling mistake

June 25, 2020
----------------
* Clone all three repositories
* Code setup on local machine
* Configure the codebase on Xcode 10.3
* Fix framework linking issues & some video renaming issues to run the codebase
* Configure the codebase on Xcode 11.4.1
* Upgrade the codebase to Swift 5.2
* Remove all possible warnings from the codebase
* Adds full screen support to present view controllers in iOS 13
* Facing a strange issue with Xcode 11.4.1 i.e breakpoints are not working and even code changes are reflecting in the app
