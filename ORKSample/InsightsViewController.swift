//
//  InsightsViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 09/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

class InsightsViewController: OCKDailyPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController,
                                          prepare listViewController: OCKListViewController, for date: Date)  {
                
        var query = OCKTaskQuery(for: date)
        query.excludesTasksWithNoEvents = true
        query.ids = [ActivityType.backPain.rawValue, ActivityType.stepsCount.rawValue,
                     ActivityType.progressTrack.rawValue]
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                if task.id == ActivityType.backPain.rawValue {
                    let backPainInsightsLineChartVC = self.backPainChartViewController(date: date, taskID: task.id)
                    listViewController.appendViewController(backPainInsightsLineChartVC, animated: false)
                } else if task.id == ActivityType.stepsCount.rawValue {
                    let stepsCountInsightsBarChartVC = self.dailyStepsChartViewController(date: date, taskID: task.id)
                    listViewController.appendViewController(stepsCountInsightsBarChartVC, animated: false)
                } else if task.id == ActivityType.progressTrack.rawValue {
                    let dailyProgressInsightsLineChartVC = self.dailyProgressChartViewController(date: date,
                                                                                                 taskID: task.id)
                    listViewController.appendViewController(dailyProgressInsightsLineChartVC, animated: false)
                }
            }
        }
    }
    
    //MARK: Helper methods
    func backPainChartViewController(date: Date, taskID: String) -> OCKCartesianChartViewController {
        let averagePainAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
            var result: Double = 0
            for event in dailyEvents {
                guard let outcome = event.outcome else { continue }
                let values = outcome.values
                if values.count == 2 {
                    var outcomeValue = values[0].stringValue ?? ""
                    if outcomeValue.contains("average:") {
                        let actualValue = Double(outcomeValue.components(separatedBy: ":").last!)!
                        result += actualValue
                    }
                    
                    outcomeValue = values[1].stringValue ?? ""
                    if outcomeValue.contains("average:") {
                        let actualValue = Double(outcomeValue.components(separatedBy: ":").last!)!
                        result += actualValue
                    }
                }
            }
            return result
        }
        
        let maxPainPainAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
            var result: Double = 0
            for event in dailyEvents {
                guard let outcome = event.outcome else { continue }
                let values = outcome.values
                if values.count == 2 {
                    var outcomeValue = values[0].stringValue ?? ""
                    if outcomeValue.contains("max:") {
                        let actualValue = Double(outcomeValue.components(separatedBy: ":").last!)!
                        result += actualValue
                    }
                    
                    outcomeValue = values[1].stringValue ?? ""
                    if outcomeValue.contains("max:") {
                        let actualValue = Double(outcomeValue.components(separatedBy: ":").last!)!
                        result += actualValue
                    }
                }
            }
            return result
        }
        
        let averagePainDataSeries = OCKDataSeriesConfiguration(
            taskID: taskID,
            legendTitle: "Average Pain",
            gradientStartColor: Colors.lightBlue.color,
            gradientEndColor: Colors.lightBlue.color,
            markerSize: 8,
            eventAggregator: averagePainAggregator)
        
        let maxPainDataSeries = OCKDataSeriesConfiguration(
            taskID: taskID,
            legendTitle: "Maximum Pain",
            gradientStartColor: Colors.blue.color,
            gradientEndColor: Colors.blue.color,
            markerSize: 8,
            eventAggregator: maxPainPainAggregator)
        
        let configurations = [averagePainDataSeries, maxPainDataSeries]
        let barChartVC = OCKCartesianChartViewController(plotType: .bar, selectedDate: date,
                                                         configurations: configurations,
                                                         storeManager: self.storeManager)
        barChartVC.chartView.headerView.titleLabel.text = "Back Pain"
        barChartVC.chartView.headerView.detailLabel.text = "This Week"
        barChartVC.chartView.headerView.accessibilityLabel = "Pain, This Week"
        return barChartVC
    }
    
    func dailyStepsChartViewController(date: Date, taskID: String) -> OCKCartesianChartViewController {
        let stepsAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
            var result: Double = 0.0
            for event in dailyEvents {
                guard let outcome = event.outcome else { continue }
                result = Double(outcome.values.first?.integerValue ?? 0)
            }
            return result
        }
        
        let stepsLineDataSeries = OCKDataSeriesConfiguration(
            taskID: taskID,
            legendTitle: "",
            gradientStartColor: Colors.blue.color,
            gradientEndColor: Colors.blue.color,
            markerSize: 4,
            eventAggregator: stepsAggregator)
        
        let lineChartVC = OCKCartesianChartViewController(plotType: .bar, selectedDate: date,
                                                          configurations: [stepsLineDataSeries],
                                                          storeManager: self.storeManager)
        lineChartVC.chartView.headerView.titleLabel.text = "Daily Steps"
        lineChartVC.chartView.headerView.detailLabel.text = ""
        lineChartVC.chartView.headerView.accessibilityLabel = "Steps, This Week"
        return lineChartVC
    }
    
    func dailyProgressChartViewController(date: Date, taskID: String) -> OCKCartesianChartViewController {
        let stepsAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
            var total: Double = 0
            var completed: Double = 0
            for event in dailyEvents {
                guard let outcome = event.outcome else { continue }
                if let intValue = outcome.values.first!.integerValue {
                    completed += Double(intValue)
                }
                
                if let strValue = outcome.values.first!.stringValue {
                    total += Double(strValue.components(separatedBy: ":").last!)!
                }
                
                if let intValue = outcome.values.last!.integerValue {
                    completed += Double(intValue)
                }
                
                if let strValue = outcome.values.last!.stringValue {
                    total += Double(strValue.components(separatedBy: ":").last!)!
                }
            }
            
            if completed > 0 {
                return ((completed/total) * 100)
            }
            
            return 0
        }
        
        let stepsLineDataSeries = OCKDataSeriesConfiguration(
            taskID: taskID,
            legendTitle: "",
            gradientStartColor: Colors.blue.color,
            gradientEndColor: Colors.blue.color,
            markerSize: 4,
            eventAggregator: stepsAggregator)
        
        let lineChartVC = OCKCartesianChartViewController(plotType: .line, selectedDate: date,
                                                          configurations: [stepsLineDataSeries],
                                                          storeManager: self.storeManager)
        lineChartVC.chartView.headerView.titleLabel.text = "Daily Progress"
        lineChartVC.chartView.headerView.detailLabel.text = ""
        lineChartVC.chartView.headerView.accessibilityLabel = "Progress, This Week"
        return lineChartVC
    }
}
