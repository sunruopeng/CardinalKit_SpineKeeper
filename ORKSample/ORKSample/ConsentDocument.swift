/*
Copyright (c) 2015, Apple Inc. All rights reserved.

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

class ConsentDocument: ORKConsentDocument {
    // MARK: Properties
    
    // title, short summary, long doc url, image url, animation url, learn more title
    let contents: [Dictionary<String, String>] = [
        [
            "title":"Overview",
            "type":ORKConsentSectionType.overview.description,
            "summary":"This simple walkthrough will explain the research study, the impact it may have on your life and will allow you to provide your consent to participate."
        ],
        [
            "title":"Activities",
            "type":ORKConsentSectionType.custom.description,
            "summary":"This study will ask you to perform tasks and respond to surveys.",
            "sectionHtmlContent":"3activities",
            "sectionImage": "00_Blank_to_Activities",
            "sectionAnimationUrl": "00_Blank_to_Activities",
            "learnMore": "Learn more"
        ],
        [
            "title":"Sensor and Health Data",
            "type":ORKConsentSectionType.custom.description,
            "summary":"This study will also gather sensor and health data from your iOS devices with your permission.",
            "sectionHtmlContent":"4sensordata",
            "sectionImage": "01_Activities_to_SensorData",
            "sectionAnimationUrl":"01_Activities_to_SensorData"
        ],
        [
            "title":"Data Gathering",
            "type":ORKConsentSectionType.dataGathering.description,
            "summary":"Collected data may allow researchers, as well as you, to understand patterns and details about back health.",
            "sectionAnimationUrl":"02_SensorData_to_DataGathering"
        ],
        [
            "title":"Protecting your Data",
            "type":ORKConsentSectionType.privacy.description,
            "summary":"Your data will be encrypted and sent to a secure database, with your name replaced by a random code.",
            "sectionHtmlContent" : "6protectingdata"
        ],
        [
            "title":"Data Use",
            "type":ORKConsentSectionType.dataUse.description,
            "summary":"Your coded study data will be used for research by Stanford and may be shared with other researchers approved by Stanford.",
            "sectionHtmlContent" : "7datause"
        ],
        [
            "title":"Your Participation",
            "type":ORKConsentSectionType.timeCommitment.description,
            "summary":"Your participation in this study will take a few minutes per day for one month. You can continue to use the app afterwards to further learn about and improve your back health.",
            "sectionHtmlContent" : "8time"
        ],
        [
            "title":"Surveys",
            "type":ORKConsentSectionType.studySurvey.description,
            "summary":"Some of the tasks in this study will require you to answer survey questions about your health and lifestyle.",
        ],
        [
            "title":"Study Tasks",
            "type":ORKConsentSectionType.studyTasks.description,
            "summary":"We will ask you to complete active tasks that may require physical activity.",
            "sectionHtmlContent" : "10study_task"
        ],
        [
            "title":"Withdrawing",
            "type":ORKConsentSectionType.withdrawing.description,
            "summary":"You may withdraw your consent and discontinue participation at any time.",
            "sectionHtmlContent" : "11withdrawing"
        ],
        [
            "title":"Potential Benefits",
            "type":ORKConsentSectionType.custom.description,
            "summary":"The information collected by this study may help you better understand and monitor your back health.",
            "sectionHtmlContent" : "12potentialbenefits1",
            "sectionImage": "10_PotentialBenifits",
            "sectionAnimationUrl": "10_PotentialBenifits"
        ],
        [
            "title":"Issues to Consider",
            "type":ORKConsentSectionType.custom.description,
            "summary":"If some questions make you uncomfortable, you can skip them.",
            "sectionImage": "11_IssuesToConsider1",
            "sectionAnimationUrl":"11_IssuesToConsider1"
        ],
        [
            "title":"Issues to Consider",
            "type":ORKConsentSectionType.custom.description,
            "summary":"Participating in this study may change how you feel. You may feel more tired, sad, energized, or happy.",
            "sectionHtmlContent" : "14issues_mood",
            "sectionImage": "12_IssuesToConsider2",
            "sectionAnimationUrl":"12_IssuesToConside2"
        ],
        [
            "title":"Issues to Consider",
            "type":ORKConsentSectionType.custom.description,
            "summary":"We will make every effort to protect your information, but total anonymity cannot be guaranteed. Regardless of where you are physically located when you use the app, your data will be sent to the United States and potentially other countries where laws may not protect your privacy to the same extent as in the country from which you sent the data.",
            "sectionHtmlContent" : "15privacy_risk",
            "sectionImage": "13_RiskToPrivacy",
            "sectionAnimationUrl":"13_RiskToPrivacy"
        ],
    ]
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        title = NSLocalizedString("Stanford SpineKeeper Study Consent Form", comment: "")
        
//        let sectionTypes: [ORKConsentSectionType] = [
//            .overview,
//            .dataGathering,
//            .privacy,
//            .dataUse,
//            .timeCommitment,
//            .studySurvey,
//            .studyTasks,
//            .withdrawing
//        ]
//        
//        sections = zip(sectionTypes, ipsum).map { sectionType, ipsum in
//            let section = ORKConsentSection(type: sectionType)
//            
//            let localizedIpsum = NSLocalizedString(ipsum, comment: "")
//            let localizedSummary = localizedIpsum.components(separatedBy: ".")[0] + "."
//            
//            section.summary = localizedSummary
//            section.content = localizedIpsum
//            
//            return section
//        }
        
        sections = contents.map { content in
            let section = ORKConsentSection(type: self.stringToORKSection(a: content["type"]!)!)
            section.title = content["title"]
            section.summary = content["summary"]
            if let html = content["sectionHtmlContent"] {
                let htmlFile = Bundle.main.path(forResource: html, ofType: "html")
                section.htmlContent = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
            }
            if let image = content["sectionImage"] {section.customImage = UIImage.init(named: image)}
            if let anim = content["sectionAnimationUrl"] {section.customAnimationURL = ORKMovieURLForString(name: anim)}
            if let learn = content["learnMore"] {section.customLearnMoreButtonTitle = learn}
            return section
        }

        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ORKMovieURLForString(name: String)->URL? {
        var scale = UIScreen.main.scale
        // For iPad, use the movie for the next scale up
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad && scale < 3) {
            scale = scale + 1
        }
        guard let url = Bundle.main.url(forResource: String.localizedStringWithFormat("%@@%dx", name, Int(scale)),
                                        withExtension: "m4v")
        else {
                return Bundle.main.url(forResource: String.localizedStringWithFormat("%@@%dx", name, Int(scale)),
                                       withExtension: "m4v")
        }
        return url;
    }
    
    private func stringToORKSection(a: String)-> ORKConsentSectionType? {
        switch a {
            case ORKConsentSectionType.overview.description:
                return ORKConsentSectionType.overview
            
            case ORKConsentSectionType.dataGathering.description:
                return ORKConsentSectionType.dataGathering
            
            case ORKConsentSectionType.privacy.description:
                return ORKConsentSectionType.privacy
            
            case ORKConsentSectionType.dataUse.description:
                return ORKConsentSectionType.dataUse
            
            case ORKConsentSectionType.timeCommitment.description:
                return ORKConsentSectionType.timeCommitment
            
            case ORKConsentSectionType.studySurvey.description:
                return ORKConsentSectionType.studySurvey
            
            case ORKConsentSectionType.studyTasks.description:
                return ORKConsentSectionType.studyTasks
            
            case ORKConsentSectionType.withdrawing.description:
                return ORKConsentSectionType.withdrawing
            
            case ORKConsentSectionType.custom.description:
                return ORKConsentSectionType.custom
            default:
                return nil
        }
    
    }
    
}

extension ORKConsentSectionType: CustomStringConvertible {

    public var description: String {
        switch self {
            case .overview:
                return "Overview"
                
            case .dataGathering:
                return "DataGathering"
                
            case .privacy:
                return "Privacy"
                
            case .dataUse:
                return "DataUse"
                
            case .timeCommitment:
                return "TimeCommitment"
                
            case .studySurvey:
                return "StudySurvey"
                
            case .studyTasks:
                return "StudyTasks"
                
            case .withdrawing:
                return "Withdrawing"
                
            case .custom:
                return "Custom"
                
            case .onlyInDocument:
                return "OnlyInDocument"
        }
    }
}
