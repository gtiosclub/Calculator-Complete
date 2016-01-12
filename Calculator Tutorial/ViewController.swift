//
//  ViewController.swift
//  Calculator Tutorial
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let calculations: CalculationDelegate = DefaultCalculations()
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonPressed(sender: UIButton) {
        setOperator("+", withFunction: +)
    }

    @IBAction func subtractButtonPressed(sender: UIButton) {
        setOperator("-", withFunction: -)
    }

    @IBAction func multiplyButtonPressed(sender: UIButton) {
        setOperator("*", withFunction: *)
    }

    @IBAction func divideButtonPressed(sender: UIButton) {
        setOperator("/", withFunction: /)
    }
    
    @IBAction func equalsButtonPressed(sender: AnyObject) {
        calculations.clearInputAndSave(true)
        resultLabel.text = calculations.resultNumber.roundedString
        reloadTable()
    }

    @IBAction func clearButtonPressed(sender: UIButton) {
        calculations.clearInputAndSave(false)
        resultLabel.text = calculations.resultNumber.roundedString
        reloadTable()
    }
    
    @IBAction func numberButtonPressed(sender: UIButton) {
        let buttonTitle = sender.titleLabel!.text!
        let buttonNumber = Int(buttonTitle)! //converts String to Int
        calculations.handleInput(buttonNumber)
        
        //also update the text on screen
        resultLabel.text = calculations.resultNumber.roundedString
    }
    
    func setOperator(character: String, withFunction function: (Double, Double) -> (Double)) {
        //DefaultOperator is part of the default CalculationDelegate
        let customOperator = DefaultOperator(forCharacter: character, withFunction: function)
        calculations.setOperator(customOperator)
        
        //again, update the text on screen
        resultLabel.text = calculations.resultNumber.roundedString
    }
    
    //MARK: - Table View Data Source
    
    func reloadTable() {
        tableView.reloadData()
        
        let lastIndex = calculations.previousExpressions.count - 1
        let indexPath = NSIndexPath(forItem: lastIndex, inSection: 0)
        if lastIndex > 0 {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculations.previousExpressions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let index = indexPath.item
        let (expression, result) = calculations.previousExpressions[index]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("paperTapeCell") as! PaperTapeCell
        cell.customize(expression + " " + result)
        return cell
    }
    
}

class PaperTapeCell : UITableViewCell {
 
    @IBOutlet weak var label: UILabel!
    
    func customize(customString: String) {
        label.text = customString
    }
    
}