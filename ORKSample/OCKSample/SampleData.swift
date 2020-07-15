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
        PressUp(),
        Breathe(),
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
        NeckPress(),
        SideBridge(),
        Plank(),
        PhysicalActivity(),
        Guidelines(),
        //
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
        StepsCount(),
        
        //Mood(),
        //ExcerciseMinutes(),
        
        //VoiceAnalysis(),
        //BackRangeOfMotion(),
        //Sleep(),
        //Journaling()
    ]
    
    // MARK: Initialization
    
    required init(carePlanStore: OCKStore) {
        super.init()
        
        //self._clearStore(store: carePlanStore)
        // Populate the store with the sample activities.
        for sampleActivity in self.activities {
            if let carePlanActivity = sampleActivity.carePlanActivity() {
                carePlanStore.addTask(carePlanActivity) { result in
                    switch result {
                    case .failure(let error): print("Error: \(error.localizedDescription)")
                    case .success: print("Successfully saved a new task!")
                    }
                }
            }
            
            //Add extra daily 6-min activities
            if sampleActivity.activityType.rawValue == ActivityType.sixMinuteWalk.rawValue {
                let sixMinuteWalk = sampleActivity as! SixMinuteWalk
                let activities = sixMinuteWalk.optionalDailySixMinActivity()
                carePlanStore.addAnyTasks(activities, callbackQueue: .main) { (result) in
                    switch result {
                    case .success(_): print("Successfully saved: Optional Daily Six Min Activity")
                    case .failure(let error): print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func resetStore(store: OCKStore) {
        self._clearStore(store: store)
    }
    
    private func _clearStore(store: OCKStore) {
        print("*** CLEANING STORE DEBUG ONLY ****")
        do {
            try store.delete()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Convenience
    
    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(_ type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }
        
        return nil
    }
}
