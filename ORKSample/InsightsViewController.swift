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
        query.ids = [ActivityType.backPain.rawValue, ActivityType.stepsCount.rawValue]
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                
                switch task.id{
                case ActivityType.backPain.rawValue:
                    
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
                        taskID: task.id,
                        legendTitle: "Average Pain",
                        gradientStartColor: Colors.lightBlue.color,
                        gradientEndColor: Colors.lightBlue.color,
                        markerSize: 8,
                        eventAggregator: averagePainAggregator)
                    
                    let maxPainDataSeries = OCKDataSeriesConfiguration(
                        taskID: task.id,
                        legendTitle: "Maximum Pain",
                        gradientStartColor: Colors.blue.color,
                        gradientEndColor: Colors.blue.color,
                        markerSize: 8,
                        eventAggregator: maxPainPainAggregator)
                    
                    let insightsBarCard = OCKCartesianChartViewController(plotType: .bar, selectedDate: date,
                                                                          configurations: [averagePainDataSeries, maxPainDataSeries],
                                                                          storeManager: self.storeManager)
                    insightsBarCard.chartView.headerView.titleLabel.text = "Back Pain"
                    insightsBarCard.chartView.headerView.detailLabel.text = "This Week"
                    insightsBarCard.chartView.headerView.accessibilityLabel = "Pain, This Week"
                    listViewController.appendViewController(insightsBarCard, animated: false)
                    
                case ActivityType.stepsCount.rawValue:
                    
                    let stepsAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
                        var result: Double = 0.0
                        for event in dailyEvents {
                            guard let outcome = event.outcome else { continue }
                            let value = outcome.values.first?.doubleValue
                            result = value ?? 0.0
                        }
                        return result
                    }
                    
                    let stepsLineDataSeries = OCKDataSeriesConfiguration(
                        taskID: task.id,
                        legendTitle: "",
                        gradientStartColor: Colors.blue.color,
                        gradientEndColor: Colors.blue.color,
                        markerSize: 4,
                        eventAggregator: stepsAggregator)
                    
                    let insightsLineCard = OCKCartesianChartViewController(plotType: .line, selectedDate: date,
                                                                           configurations: [stepsLineDataSeries],
                                                                           storeManager: self.storeManager)
                    insightsLineCard.chartView.headerView.titleLabel.text = "Daily Steps"
                    insightsLineCard.chartView.headerView.detailLabel.text = ""
                    insightsLineCard.chartView.headerView.accessibilityLabel = "Steps, This Week"
                    
                    listViewController.appendViewController(insightsLineCard, animated: false)
                    
                default:
                    print("")
                }
                
            }
        }
    }
}
