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
import ResearchKit

// Junaid Commnented

//class BuildInsightsOperation: Operation {
//
//    // MARK: Properties
//
//    var medicationEvents: [(dateComponent: DateComponents, value: Double)]?
//    var backPainEvents: DailyEvents?
//    var backPain2Events: DailyEvents?
//    var backPainLineGraphEvents: DailyEvents?
//
//    fileprivate(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
//
//    // MARK: NSOperation
//
//    override func main() {
//        // Do nothing if the operation has been cancelled.
//        guard !isCancelled else { return }
//
//        // Create an array of insights.
//        //var newInsights = [OCKInsightItem]()
//
//        if let insight = createDaysInStudyInsight()         { newInsights.append(insight) }
//        //if let insight = createMedicationAdherenceInsight() { newInsights.append(insight) }
//        if let insight = createBackPainInsight()            { newInsights.append(insight) }
//        if let insight = createBackPainLineGraphInsight()   { newInsights.append(insight) }
//
//        // Store any new insights thate were created.
//        if !newInsights.isEmpty { insights = newInsights }
//    }
//
//    // MARK: Convenience
//
//    func createDaysInStudyInsight() -> OCKInsightItem? {
//        let now = Date()
//        let calendar = Calendar.autoupdatingCurrent
//        let day2 = calendar.startOfDay(for: now)
//        let startDate = UserDefaults.standard.object(forKey: "startDate")
//        let day1 = (startDate != nil) ? calendar.startOfDay(for: startDate as! Date) : day2 // make original start day
//        let components = calendar.dateComponents([.day], from: day1, to: day2)
//
//        var mes:String
//        if components.day! < 4 { mes = "Thanks for getting started!"}
//        else if components.day! < 7 {mes = "Almost 1 week completed!"}
//        else {mes = "Thanks for your participation!"}
//
//        let insight = OCKMessageItem(title: "Days in Study: \(components.day ?? 1)", text: mes, tintColor: Colors.lightBlue.color, messageType: .alert)
//        return insight
//    }
//    /*
//    func createMedicationAdherenceInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let medicationEvents = medicationEvents else { return nil }
//        // Determine the start date for the previous week.
//        let calendar = Calendar.current
//        let now = Date()
//        var components = DateComponents()
//        components.day = -7
//        let startDate = calendar.weekDatesForDate(calendar.date(byAdding: components as DateComponents, to: now)!).start
//        var totalEventCount = 0
//        var completedEventCount = 0
//
//        for offset in 0..<7 {
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//            let eventsForDay = medicationEvents[dayComponents]
//            totalEventCount += eventsForDay.count
//            //print ("total " + eventsForDay.count.description)
//            for event in eventsForDay {
//                if event.state == .completed {
//                    completedEventCount += 1
//                }
//                //print(completedEventCount)
//            }
//        }
//        guard totalEventCount > 0 else { return nil }
//        // Calculate the percentage of completed events.
//        let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
//        // Create an `OCKMessageItem` describing medical adherence.
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))!
//        let insight = OCKMessageItem(title: "Activity Habits", text: "You completed \(formattedAdherence) of your recommended activities in the past 7 days.", tintColor: Colors.pink.color, messageType: .alert)
//        return insight
//    }*/
//
//    func createBackPainInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let backPainEvents = backPainEvents else { return nil }
//
//        // Determine the date to start pain/medication comparisons from.
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.day = -7
//
//        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
//
//        // Create formatters for the data.
//        let dayOfWeekFormatter = DateFormatter()
//        dayOfWeekFormatter.dateFormat = "E"
//
//        let shortDateFormatter = DateFormatter()
//        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
//
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//
//        /*
//            Loop through 7 days, collecting medication adherance and pain scores
//            for each.
//        */
//        var medicationValues = [Int]()
//        var medicationLabels = [String]()
//        var painValues = [Int]()
//        var painLabels = [String]()
//        var axisTitles = [String]()
//        var axisSubtitles = [String]()
//
//        for offset in 0..<7 {
//            // Determine the day to components.
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//
//            // Store the pain result for the current day.
//            let result = backPainEvents[dayComponents].first?.result
//            let scorestring = result?.valueString
//            let scores = scorestring?.components(separatedBy: ",")
//            let score = Int(scores?[0] ?? "0")
//            if score! > 0 {
//                painValues.append(score!)
//                painLabels.append(scores?[0] ?? NSLocalizedString("N/A", comment: ""))
//            }
//            else {
//                painValues.append(0)
//                painLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//            let score2 = Int(scores?[1] ?? "0")
//            if score2! > 0 {
//                medicationValues.append(score2!)
//                medicationLabels.append(scores?[1] ?? NSLocalizedString("N/A", comment: ""))
//            }
//            else {
//                medicationValues.append(0)
//                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
//
//            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
//            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
//        }
//
//        // Create a `OCKBarSeries` for each set of data.
//        let painBarSeries = OCKBarSeries(title: "Average Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.blue.color)
//        let medicationBarSeries = OCKBarSeries(title: "Maximum Pain", values: medicationValues as [NSNumber], valueLabels: medicationLabels, tintColor: Colors.lightBlue.color)
//
//        /*
//            Add the series to a chart, specifing the scale to use for the chart
//            rather than having CareKit scale the bars to fit.
//        */
//        let chart = OCKBarChart(title: "Back Pain",
//                                text: nil,
//                                tintColor: Colors.blue.color,
//                                axisTitles: axisTitles,
//                                axisSubtitles: axisSubtitles,
//                                dataSeries: [painBarSeries, medicationBarSeries],
//                                minimumScaleRangeValue: 0,
//                                maximumScaleRangeValue: 10)
//
//        return chart
//    }
//
//
////    func createBackPainInsight() -> OCKInsightItem? {
////        // Make sure there are events to parse.
////        guard let medicationEvents = medicationEvents, let backPainEvents = backPainEvents else { return nil }
////
////        // Determine the date to start pain/medication comparisons from.
////        let calendar = Calendar.current
////        var components = DateComponents()
////        components.day = -7
////
////        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
////
////        // Create formatters for the data.
////        let dayOfWeekFormatter = DateFormatter()
////        dayOfWeekFormatter.dateFormat = "E"
////
////        let shortDateFormatter = DateFormatter()
////        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
////
////        let percentageFormatter = NumberFormatter()
////        percentageFormatter.numberStyle = .percent
////
////        /*
////            Loop through 7 days, collecting medication adherance and pain scores
////            for each.
////        */
////        var medicationValues = [Float]()
////        var medicationLabels = [String]()
////        var painValues = [Int]()
////        var painLabels = [String]()
////        var axisTitles = [String]()
////        var axisSubtitles = [String]()
////
////        for offset in 0..<7 {
////            // Determine the day to components.
////            components.day = offset
////            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
////            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
////
////            // Store the pain result for the current day.
////            if let result = backPainEvents[dayComponents].first?.result, let score = Int(result.valueString) , score > 0 {
////                painValues.append(score)
////                painLabels.append(result.valueString)
////            }
////            else {
////                painValues.append(0)
////                painLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
////
////            // Store the medication adherance value for the current day.
////            let medicationEventsForDay = medicationEvents[dayComponents]
////            if let adherence = percentageEventsCompleted(medicationEventsForDay) , adherence > 0.0 {
////                // Scale the adherance to the same 0-10 scale as pain values.
////                let scaledAdeherence = adherence * 10.0
////
////                medicationValues.append(scaledAdeherence)
////                medicationLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
////            }
////            else {
////                medicationValues.append(0.0)
////                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
////
////            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
////            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
////        }
////
////        // Create a `OCKBarSeries` for each set of data.
////        let painBarSeries = OCKBarSeries(title: "Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.blue.color)
////        let medicationBarSeries = OCKBarSeries(title: "Medication Adherence", values: medicationValues as [NSNumber], valueLabels: medicationLabels, tintColor: Colors.lightBlue.color)
////
////        /*
////            Add the series to a chart, specifing the scale to use for the chart
////            rather than having CareKit scale the bars to fit.
////        */
////        let chart = OCKBarChart(title: "Back Pain",
////                                text: nil,
////                                tintColor: Colors.blue.color,
////                                axisTitles: axisTitles,
////                                axisSubtitles: axisSubtitles,
////                                dataSeries: [painBarSeries, medicationBarSeries],
////                                minimumScaleRangeValue: 0,
////                                maximumScaleRangeValue: 10)
////
////        return chart
////    }
//
//    func createBackPainLineGraphInsight() -> OCKInsightItem? {
//        // Make sure there are events to parse.
//        guard let medicationEvents = medicationEvents, let backPainEvents = backPainEvents else { return nil }
//
//        // Determine the date to start pain/medication comparisons from.
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.day = -7
//
//        let startDate = calendar.date(byAdding: components as DateComponents, to: Date())!
//
//        // Create formatters for the data.
//        let dayOfWeekFormatter = DateFormatter()
//        dayOfWeekFormatter.dateFormat = "E"
//
//        let shortDateFormatter = DateFormatter()
//        shortDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: shortDateFormatter.locale)
//
//        let percentageFormatter = NumberFormatter()
//        percentageFormatter.numberStyle = .percent
//
//        /*
//         Loop through 7 days, collecting medication adherance and pain scores
//         for each.
//         */
//        var medicationValues = [Int]()
//        var medicationLabels = [String]()
//        var painValues = [Int]()
//        var painLabels = [String]()
//        var axisTitles = [String]()
//        var axisSubtitles = [String]()
//
//        for offset in 0..<7 {
//            // Determine the day to components.
//            components.day = offset
//            let dayDate = calendar.date(byAdding: components as DateComponents, to: startDate)!
//            let dayComponents = calendar.dateComponents([.year, .month, .day, .era], from: dayDate)
//
//            // Store the pain result for the current day.
//            let result = backPainEvents[dayComponents].first?.result
//            let scorestring = result?.valueString
//            let scores = scorestring?.components(separatedBy: ",")
//            let score = Int(scores?[0] ?? "0")
//            if score! > 0 {
//                painValues.append(score!)
//                painLabels.append(scores?[0] ?? NSLocalizedString("N/A", comment: ""))
//            }
//            else {
//                painValues.append(0)
//                painLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//            let score2 = medicationEvents[offset].value*10
//            //let score2 = Int(scores?[1] ?? "0")
//            if score2 > 0.001 {
//                medicationValues.append(Int(score2))
//                medicationLabels.append(String(Int(score2)))
//            }
//            else {
//                medicationValues.append(0)
//                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
//            }
//
////            // Store the pain result for the current day.
////            if let result = backPainEvents[dayComponents].first?.result, let score = Int(result.valueString) , score > 0 {
////                painValues.append(score)
////                painLabels.append(result.valueString)
////            }
////            else {
////                painValues.append(0)
////                painLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
////
////            // Store the medication adherance value for the current day.
////            let medicationEventsForDay = medicationEvents[dayComponents]
////            if let adherence = percentageEventsCompleted(medicationEventsForDay) , adherence > 0.0 {
////                // Scale the adherance to the same 0-10 scale as pain values.
////                let scaledAdeherence = adherence * 10.0
////
////                medicationValues.append(scaledAdeherence)
////                medicationLabels.append(percentageFormatter.string(from: NSNumber(value: adherence))!)
////            }
////            else {
////                medicationValues.append(0.0)
////                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
////            }
//
//            axisTitles.append(dayOfWeekFormatter.string(from: dayDate))
//            axisSubtitles.append(shortDateFormatter.string(from: dayDate))
//        }
//
//        // Create a `OCKBarSeries` for each set of data.
//        let painBarSeries = OCKBarSeries(title: "Average Pain", values: painValues as [NSNumber], valueLabels: painLabels, tintColor: Colors.blue.color)
//        let medicationBarSeries = OCKBarSeries(title: "Maximum Pain", values: medicationValues as [NSNumber], valueLabels: medicationLabels, tintColor: Colors.cardinalRed.color)
//
//        /*
//         Add the series to a chart, specifing the scale to use for the chart
//         rather than having CareKit scale the bars to fit.
//         */
//        let chart = OCKBarChart(title: "Back Pain",
//                                text: nil,
//                                tintColor: Colors.blue.color,
//                                axisTitles: axisTitles,
//                                axisSubtitles: axisSubtitles,
//                                dataSeries: [painBarSeries, medicationBarSeries],
//                                minimumScaleRangeValue: 0,
//                                maximumScaleRangeValue: 10)
//
//        //let chart2 = CKLineGraph.init(withDataSource: LineGraphDataSource(), tintColor: Colors.blue.color, referenceLineColor: Colors.green.color)
//
//        DispatchQueue.main.async {
//            let yo = UIApplication.shared.delegate as! AppDelegate
//            let yo2 = yo.containerViewController?.dashboardVC
//            yo2?.lineGraphDataSource.plotPoints = [medicationValues.map{val in ORKValueRange(value: Double(val))},
//                                                   //painValues.map{val in ORKValueRange(value: Double(val))},
//                                                  ]
//            yo2?.lineGraphDataSource.maxVal = 10.0
//            yo2?.lineGraphDataSource.minVal = 0.0
//        }
//
//        // so this is just a dummy to make insightsviewcontroller do what i want with the dashboardVC line graph
//        return CKLineGraph(withTitle: "Activity Routine Trends")
//    }
//
//
//
//
//
//    /**
//        For a given array of `OCKCarePlanEvent`s, returns the percentage that are
//        marked as completed.
//    */
//    fileprivate func percentageEventsCompleted(_ events: [OCKCarePlanEvent]) -> Float? {
//        guard !events.isEmpty else { return nil }
//
//        let completedCount = events.filter({ event in
//            event.state == .completed
//        }).count
//
//        return Float(completedCount) / Float(events.count)
//    }
//}
//
///**
// An extension to `SequenceType` whose elements are `OCKCarePlanEvent`s. The
// extension adds a method to return the first element that matches the day
// specified by the supplied `NSDateComponents`.
// */
//extension Sequence where Iterator.Element: OCKCarePlanEvent {
//
//    func eventForDay(_ dayComponents: NSDateComponents) -> Iterator.Element? {
//        for event in self where
//                event.date.year == dayComponents.year &&
//                event.date.month == dayComponents.month &&
//                event.date.day == dayComponents.day {
//            return event
//        }
//
//        return nil
//    }
//}
