/*
 Copyright (c) 2016, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import ResearchKit
import CareKit

class SampleData: NSObject {
    
    // MARK: Properties

    /// An array of `Activity`s used in the app.
    let activities: [Activity] = [
        //PressUp(),
        BackwardBending(),
        FrontalCoreStretch(),
        HamstringStretch(),
        InnerThighStretch(),
        StandingThreadTheNeedle(),
        DoorwayChestStretch(),
        WallWash(),
        Brace(),
        Diary(),
        TransverseCore(),
        SagittalCore(),
        AbdominalCrunch(),
        //NeckPress(), Junaid Commnented
        SideBridge(),
        Plank(),
        PhysicalActivity(),
        Guidelines(),
        
        NassVideo1(),
        NassVideo2(),
        NassVideo3(),
        NassVideo4(),
        NassVideo5(),
        NassVideo6(),
        NassVideo7(),
        NassVideo8(),
        NassVideo9(),
        
        IceHeat(),
        LayFlat(),
        ExerciseType(),
        BackFacts(),
        CausesOfBackPain(),
        Dealing1(),
        Dealing2(),
        Dealing3(),
        ChronicPain(),
        StayingActive1(),
        StayingActive2(),
        Sleep1(),
        Sleep2(),
        Myth1(),
        Myth2(),
        Myth3(),
        Myth4(),
        Myth5(),
        Myth6(),
        Myth7(),
        Myth8(),
        Myth9(),
        Myth10(),
        Coping(),
        CopingRefresher1(),
        CopingRefresher2(),
        SummaryFacts(),
        
        StartBackSurvey(),
        ODISurvey(),
        BackPain(),
        Weight(),
        SixMinuteWalk(),
        
        //Mood(),
        //ExcerciseMinutes(),
        
        //VoiceAnalysis(),
        //BackRangeOfMotion(),
        //Sleep(),
        //Journaling()
    ]
    
    /**
        An array of `OCKContact`s to display on the Connect view.
    */
    /* Junaid Commnented
    
    let contacts: [OCKContact] = [
        OCKContact(contactType: .careTeam,
            name: "Dr. Maria Ruiz",
            relation: "Physician",
			contactInfoItems:[.phone("888-555-5512"), .sms("888-555-5512"), .email("mruiz2@mac.com")],
            tintColor: Colors.blue.color,
            monogram: "MR",
            image: nil),
        
        OCKContact(contactType: .careTeam,
            name: "Bill James",
            relation: "Nurse",
			contactInfoItems:[.phone("888-555-5512"), .sms("888-555-5512"), .email("billjames2@mac.com")],
            tintColor: Colors.green.color,
            monogram: nil,
            image: nil),
        
        OCKContact(contactType: .personal,
            name: "Tom Clark",
            relation: "Father",
			contactInfoItems:[.phone("888-555-5512"), .sms("888-555-5512"), .facetimeVideo("8885555512", display: "888-555-5512")],
            tintColor: Colors.yellow.color,
            monogram: nil,
            image: nil)
    ]
 
 */
    
    // MARK: Initialization

    /* Junaid Commnented
    required init(carePlanStore: OCKCarePlanStore) {
        super.init()
        
        //self._clearStore(store: carePlanStore)
        // Populate the store with the sample activities.
        for sampleActivity in self.activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.add(carePlanActivity) { success, error in
                if !success {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
 
 */
 
    /* Junaid Commnented
    func resetStore(store: OCKCarePlanStore) {
        self._clearStore(store: store)
    }
    
    private func _clearStore(store: OCKCarePlanStore) {
        print("*** CLEANING STORE DEBUG ONLY ****")
        
        let deleteGroup = DispatchGroup()

        deleteGroup.enter()
        store.activities { (success, activities, errorOrNil) in
            
            guard success else {
                // Perform proper error handling here...
                fatalError(errorOrNil!.localizedDescription)
            }
            
            for activity in activities {
                
                deleteGroup.enter()
                store.remove(activity) { (success, error) -> Void in
                    
                    print("Removing \(activity)")
                    guard success else {
                        fatalError("*** An error occurred: \(error!.localizedDescription)")
                    }
                    print("Removed: \(activity)")
                    deleteGroup.leave()
                }
            }
            deleteGroup.leave()
        }
        
        // Wait until all the asynchronous calls are done.
        DispatchGroup().wait(timeout: DispatchTime.distantFuture)
    }
    
    */
    
    // MARK: Convenience
    
    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(_ type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }
        
        return nil
    }
    
    /* Junaid Commnented
    
    func generateSampleDocument() -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "First subtitle")
        
        let paragraph = OCKDocumentElementParagraph(content: "Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque.")
            
        let document = OCKDocument(title: "Sample Document Title", elements: [subtitle, paragraph])
        document.pageHeader = "App Name: OCKSample, User Name: John Appleseed"
        
        return document
    }
    
    */
}
