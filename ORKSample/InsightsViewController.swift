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
        query.ids = [ActivityType.backPain.rawValue]
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            
            guard let tasks = try? result.get() else { return }
            
            tasks.forEach { task in
                let averagePainAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
                    let values = dailyEvents.map { $0.outcome?.values[0].integerValue ?? 0 }
                    let sumTotal = values.reduce(0, +)
                    return Double(sumTotal)
                }
                
                let maxPainPainAggregator = OCKEventAggregator.custom { dailyEvents -> Double in
                    let values = dailyEvents.map { $0.outcome?.values[1].integerValue ?? 0 }
                    let sumTotal = values.reduce(0, +)
                    return Double(sumTotal)
                }
                
                // Create a plot comparing nausea to medication adherence.
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
                
                
                let averagePainLineDataSeries = OCKDataSeriesConfiguration(
                    taskID: task.id,
                    legendTitle: "",
<<<<<<< HEAD
                    gradientStartColor: Colors.stanfordAqua.color,
                    gradientEndColor: Colors.stanfordAqua.color,
=======
                    gradientStartColor: Colors.lightBlue.color,
                    gradientEndColor: Colors.lightBlue.color,
>>>>>>> 1eec93b346a382c5ab8ee4d3ed2d4a9b7edd8cc5
                    markerSize: 4,
                    eventAggregator: averagePainAggregator)
                
                let maxPainLineDataSeries = OCKDataSeriesConfiguration(
                    taskID: task.id,
                    legendTitle: "",
                    gradientStartColor: Colors.blue.color,
                    gradientEndColor: Colors.blue.color,
                    markerSize: 4,
                    eventAggregator: maxPainPainAggregator)
                
                let insightsBarCard = OCKCartesianChartViewController(plotType: .bar, selectedDate: date,
                                                                      configurations: [averagePainDataSeries, maxPainDataSeries],
                                                                      storeManager: self.storeManager)
                insightsBarCard.chartView.headerView.titleLabel.text = "Back Pain"
                insightsBarCard.chartView.headerView.detailLabel.text = "This Week"
                insightsBarCard.chartView.headerView.accessibilityLabel = "Pain, This Week"
                
                let insightsLineCard = OCKCartesianChartViewController(plotType: .line, selectedDate: date,
                                                                       configurations: [averagePainLineDataSeries,maxPainLineDataSeries],
                                                                       storeManager: self.storeManager)
                insightsLineCard.chartView.headerView.titleLabel.text = "Activity Routine Trends"
                insightsLineCard.chartView.headerView.detailLabel.text = ""
                insightsLineCard.chartView.headerView.accessibilityLabel = "Pain, This Week"
                
                listViewController.appendViewController(insightsBarCard, animated: false)
                listViewController.appendViewController(insightsLineCard, animated: false)
            }
        }
    }
}
