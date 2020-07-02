//
//  CKLineGraph.swift
//  ORKSample
//
//  Created by Aman Sinha on 4/13/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import CareKit
import ResearchKit

/*  Junaid Commnented

class CKLineGraph : OCKChart {
    
    var lineGraph : ORKLineGraphChartView!
    var dataSource : LineGraphDataSource!
    var container : UIView! // maybe dont need
    
    init(withTitle title: String) {
        super.init()
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func chartView() -> UIView {
        let yo = UIApplication.shared.delegate as! AppDelegate
        let yo2 = yo.containerViewController?.dashboardVC
        while (lineGraph == nil) {
            yo2?.view.setNeedsLayout()
            yo2?.view.setNeedsDisplay()
            container = yo2?.lineGraphContainer
            lineGraph = yo2?.lineGraph
            dataSource = yo2?.lineGraphDataSource
        }
        // forces redraw
        lineGraph.dataSource = dataSource
        return lineGraph//container
    }
    
    override class func animate(_ view: UIView, withDuration duration: TimeInterval) {
        guard let animatableChart = view as? AnimatableChart else { return }
        animatableChart.animateWithDuration(duration)
//        for v in view.subviews {
//            let animChart = v as? AnimatableChart
//            if (animChart != nil) {
//                animChart?.animateWithDuration(duration)
//            }
//        }
    }












}

*/
