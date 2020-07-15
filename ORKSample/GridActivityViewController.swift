//
//  GridActivityViewController.swift
//  ORKSample
//
//  Created by Muhammad Junaid Butt on 10/07/2020.
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import CareKit

class GridActivityViewController: OCKGridTaskViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //override method to show custom text on the labels
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! OCKGridTaskView.DefaultCellType
        cell.completionButton.label.text = indexPath.row == 0 ? "Morning" : "Evening"
        return cell
    }
    
    //This method will call when you will tap on the "Mark as Completed" button
    override func taskView(_ taskView: UIView & OCKTaskDisplayable,
                           didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {
        //if user un-mark the activity then delete its results from the datastore as well
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            //get the event
            guard let event = controller.eventFor(indexPath: indexPath) else { return }
            //if outcome is saved then delete it
            if let outcome = event.outcome {
                controller.store.deleteAnyOutcome(outcome, callbackQueue: .main, completion: nil)
            }
            
            //Update the daily progress
            CareStoreReferenceManager.shared.updateProgress(by: -1, for: event.scheduleEvent.start)
            return
        }
        
        //Save results
        guard
            let event = controller.eventFor(indexPath: indexPath),
            let taskID = (event.task as! OCKTask).localDatabaseID
            else { return }
        
        let outcome = OCKOutcome(taskID: taskID, taskOccurrenceIndex: event.scheduleEvent.occurrence,
                                 values: [OCKOutcomeValue(1)])
        controller.store.addAnyOutcome(outcome, callbackQueue: .main) { (result) in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(_):
                print("Outcome created")
                
                //Update the daily progress
                CareStoreReferenceManager.shared.updateProgress(by: 1, for: event.scheduleEvent.start)
            }
        }
    }
    
    //This method is called when the user taps the card for detail view
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        guard let event = controller.eventFor(indexPath: eventIndexPath) else { return }
        guard let task = event.task as? OCKTask else { return }
        do {
            let detailsVC = try controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
            detailsVC.navigationItem.rightBarButtonItem = nil
            if let asset = task.asset {
                detailsVC.detailView.imageView.contentMode = .scaleAspectFit
                detailsVC.detailView.imageView.image = UIImage(named: asset)
            }
            
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(string: task.title!,
                                                     attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .semibold)]))
            attributedText.append(NSAttributedString(string: "\n"))
            attributedText.append(NSAttributedString(string: event.scheduleEvent.element.text!,
                                                     attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .light)]))
            detailsVC.detailView.titleLabel.attributedText = attributedText
            detailsVC.detailView.titleLabel.textAlignment = .center
            detailsVC.detailView.instructionsLabel.text = task.instructions
            self.navigationController?.pushViewController(detailsVC, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}
