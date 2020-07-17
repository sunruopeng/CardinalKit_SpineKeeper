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

import CareKit

/**
 Protocol that defines the properties and methods for sample activities.
 */
protocol Activity {
    var activityType: ActivityType { get }
    
    func carePlanActivity() -> OCKTask?
}

/**
 Enumeration of strings used as identifiers for the `SampleActivity`s used in
 the app.
 */
enum ActivityType: String {
    // Things that have to do - intervention
    case pressUp
    case breathe
    case backwardBending
    case frontalCoreStretch
    case hamstringStretch
    case innerThighStretch
    case standingThreadTheNeedle
    case doorwayChestStretch
    case wallWash
    case brace
    case diary
    case transverseCore
    case sagittalCore
    case abdominalCrunch
    case abdominalExercise
    case neckPress
    case sideBridge
    case plank
    case physicalActivity
    case guidelines
    
    //intervention, learn
    case nassVideo1
    case nassVideo2
    case nassVideo3
    case nassVideo4
    case nassVideo5
    case nassVideo6
    case nassVideo7
    case nassVideo8
    case nassVideo9
    
    case iceHeat
    case layFlat
    case exerciseType
    case backFacts
    case causesOfBackPain
    case dealing1
    case dealing2
    case dealing3
    case chronicPain
    case stayingActive1
    case stayingActive2
    case sleep1
    case sleep2
    case myth1
    case myth2
    case myth3
    case myth4
    case myth5
    case myth6
    case myth7
    case myth8
    case myth9
    case myth10
    case coping
    case copingRefresher1
    case copingRefresher2
    case summaryFacts
    case stepsCount
    case progressTrack
    
    // things to measure - assessment
    case startBackSurvey
    case odiSurvey
    case backPain // done
    case mood //done
    case excerciseMinutes
    case weight // done
    case sixMinuteWalk
    case sixMinuteWalkOptional
    case sleep
    case voiceAnalysis
    case backRangeOfMotion
    case journaling
}
