//
//  VitalsGraphViewController.swift
//  QardiyoHF_Patient
//
//  Created by Ashish kumar patel on 10/08/18.
//  Copyright © 2018 Vog Calgary App Developer Inc. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import DatePickerDialog


class VitalsGraphViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectDateBarButton: UIBarButtonItem!
    
    @IBAction func renderCharts() {
        //  barChartUpdate()
        //  pieChartUpdate()
    }
    
    func setuplineChar(){
        lineChart.chartDescription?.enabled = true
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        lineChart.highlightPerDragEnabled = true
        lineChart.backgroundColor = .white
        lineChart.legend.enabled = true
        
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .top
        //   xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        //   xAxis.granularity = 60
        //    xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelPosition = .outsideChart
        //  leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        //  leftAxis.axisMinimum = 0
        //  leftAxis.axisMaximum = 170
        //leftAxis.yOffset = 0
        leftAxis.labelTextColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        lineChart.rightAxis.enabled = false
        lineChart.legend.form = .line
        // sliderX.value = 100
        //  slidersValueChanged(nil)
        
        lineChart.animate(xAxisDuration: 1)
        // setDataCount(30, range: 80)
    }
    
    
    var patientCharDataModel = PatientCharDataModel()
    var selectedTimeInterVal = 0
    var selectedCategory = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vitals"
        collectionView.allowsMultipleSelection = false;
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
    }
    
    
    @IBAction func selectDateAction(_ sender: UIBarButtonItem) {
        let dataPicker =    DatePickerDialog(textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), buttonColor: #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1), font: . boldSystemFont(ofSize: 15), locale: nil, showCancelButton: true)
        dataPicker.show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat =   "yyyy-MM-dd"
                print(formatter.string(from: dt))
                let dateWithDDMMYY = formatter.string(from: dt)
                
                formatter.dateFormat =   "yyyy"
                print(formatter.string(from: dt))
                let year = formatter.string(from: dt)
                self.selectDateBarButton.title = dateWithDDMMYY
                
                Messages.getPatientChartData(data: dateWithDDMMYY, year: year) { (pateint) in
                    self.patientCharDataModel = pateint
                    self.loadChartAccourdingToSelectedCategoryAndTimeInterval(category: self.selectedCategory, timeInterVal: self.selectedTimeInterVal)
                    self.collectionView.reloadData ()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Messages.getPatientChartData(data: getCurrentDate(), year: getCurrentYear()) { (pateint) in
            self.patientCharDataModel = pateint
            self.loadChartAccourdingToSelectedCategoryAndTimeInterval(category: self.selectedCategory, timeInterVal: self.selectedTimeInterVal)
            self.collectionView.reloadData ()
            self.selectDateBarButton.title = self.getCurrentDate()
        }
    }
    
    func getCurrentDate()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func getCurrentYear()->String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func convertStepToKM(steps:String)->String{
        if let  tempStep = Double(steps){
            return  "\(String(format: "%.2f", tempStep/1312 ))"
        }
        return "0.0"
    }
    
    
    func loadChartAccourdingToSelectedCategoryAndTimeInterval(category:Int, timeInterVal: Int){
        switch category {
        case 0:
            loadDiastolicData(selectedIndex: timeInterVal)
        case 1:
            loadHeartRateData (selectedIndex: timeInterVal)
        case 2:
            loadStepCountData(selectedIndex: timeInterVal)
        case 3:
            loadWeightData(selectedIndex: timeInterVal)
        case 4:
            loadSleepMinuteData(selectedIndex: timeInterVal)
        case 5:
            loadSystolicData(selectedIndex: timeInterVal)
        default:
            print("This is first category")
        }
    }
    
    
    func loadStepCountData(selectedIndex:Int){
        var barChartEntry = [BarChartDataEntry]()
        barChart.clear()
        barChart.setScaleEnabled(false)
        barChart.pinchZoomEnabled = false
        switch selectedIndex {
        case 0:
            barChart.xAxis.valueFormatter = nil
            barChart.xAxis.axisMinimum = 0
            barChart.xAxis.axisMaximum = 24
            barChart.xAxis.labelCount = 12
            //barChart.xAxis.axisMinimum = 6
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgSteps), let xValue = Double(data.hour) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Daily")
            barChartUpdate(barcodeSet: dataSet)
            
        case 1:
            
            barChart.xAxis.labelCount = 7
            barChart.xAxis.axisMinimum = 0
            barChart.xAxis.axisMaximum = 6
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgSteps), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Weekly")
            barChartUpdate(barcodeSet: dataSet)
        case 2:
            
            barChart.xAxis.labelCount = 15
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.axisMinimum = 1
            barChart.xAxis.axisMaximum = 31
            barChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgSteps), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Monthly")
            barChartUpdate(barcodeSet: dataSet)
        case 3:
            
            barChart.xAxis.labelCount = 12
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.axisMinimum = 1
            barChart.xAxis.axisMaximum = 12
            barChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgSteps), let xValue = Double(data.monthNo) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Yearly")
            //            let xAxis = barChart.xAxis
            //            xAxis.valueFormatter =DayAxi
            barChartUpdate(barcodeSet: dataSet)
        default:
            print("defalt case")
        }
    }
    
    
    func loadSleepMinuteData(selectedIndex:Int){
        var barChartEntry = [BarChartDataEntry]()
        barChart.clear()
        barChart.leftAxis.axisMinimum = 0
        barChart.rightAxis.axisMinimum = 0
        
        
        switch selectedIndex {
        case 0:
            barChart.xAxis.axisMinimum = 0
            barChart.xAxis.axisMaximum = 24
            barChart.xAxis.labelCount = 12
            barChart.xAxis.valueFormatter = nil
            // barChart.xAxis.granularityEnabled = true
            //barChart.xAxis.axisMinimum = 6
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgSleepMinutes), let xValue = Double(data.hour) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Daily")
            barChartUpdate(barcodeSet: dataSet)
        case 1:
            barChart.xAxis.labelCount = 7
            barChart.xAxis.axisMinimum = 0
            barChart.xAxis.axisMaximum = 6
            barChart.xAxis.labelCount = 7
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgSleepMinutes), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Weekly")
            barChartUpdate(barcodeSet: dataSet)
        case 2:
            
            barChart.xAxis.labelCount = 15
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.axisMinimum = 1
            barChart.xAxis.axisMaximum = 31
            barChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgSleepMinutes), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Monthly")
            barChartUpdate(barcodeSet: dataSet)
        case 3:
            
            barChart.xAxis.labelCount = 12
            barChart.xAxis.forceLabelsEnabled = true
            barChart.xAxis.granularityEnabled = true
            barChart.xAxis.granularity = 1
            barChart.xAxis.axisMinimum = 1
            barChart.xAxis.axisMaximum = 12
            barChart.xAxis.valueFormatter = nil
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgSleepMinutes), let xValue = Double(data.monthNo) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    barChartEntry.append(entry)
                }
            }
            if barChartEntry.count == 0{
                return
            }
            let dataSet = BarChartDataSet(values:barChartEntry, label: "Yearly")
            //            let xAxis = barChart.xAxis
            //            xAxis.valueFormatter =DayAxi
            barChartUpdate(barcodeSet: dataSet)
        default:
            print("defalt case")
        }
    }
    
    
    
    func loadHeartRateData(selectedIndex:Int){
        var lineChartEntry = [ChartDataEntry]()
        lineChart.clear()
        switch selectedIndex {
        case 0:
            lineChart.xAxis.valueFormatter = nil
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 24
            lineChart.xAxis.labelCount = 12
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgHeartRate), let xValue = Double(data.hour) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Daily")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 1:
            lineChart.xAxis.labelCount = 7
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 6
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgHeartRate), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "weekly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 2:
            
            lineChart.xAxis.labelCount = 15
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 31
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgHeartRate), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Monthly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
        case 3:
            
            lineChart.xAxis.labelCount = 12
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 12
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgHeartRate), let xValue = Double(data.monthNo) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Yearly")
            let data = LineChartData(dataSet: dataSet)
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            data.setValueTextColor(.red)
            lineChart.data = data
        default:
            print("defalt case")
        }
    }
    
    
    func loadDiastolicData(selectedIndex:Int){
        var lineChartEntry = [ChartDataEntry]()
        var lineChartEntry1 = [ChartDataEntry]()
        lineChart.clear()
        
        switch selectedIndex {
        case 0:
            lineChart.xAxis.valueFormatter = nil
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 24
            lineChart.xAxis.labelCount = 12
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgBPDiastolic), let xValue = Double(data.hour) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.hour) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry1.append(entry)
                }
            }
            if lineChartEntry.count == 0 || lineChartEntry1.count==0 {
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Diastolic")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.setCircleColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            
            let dataSet1 = LineChartDataSet(values:lineChartEntry1, label: "Systolic")
            dataSet1.axisDependency = .left
            dataSet1.setColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.lineWidth = 3.0
            dataSet1.drawCirclesEnabled = true
            dataSet1.drawValuesEnabled = true
            dataSet1.setCircleColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.fillAlpha = 0.26
            dataSet1.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            dataSet1.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet1.drawCircleHoleEnabled = true
            
            let data = LineChartData(dataSets: [dataSet1, dataSet])
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 1:
            lineChart.xAxis.labelCount = 7
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 6
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgBPDiastolic), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry1.append(entry)
                }
            }
            if lineChartEntry.count == 0 || lineChartEntry1.count==0 {
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Diastolic")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.setCircleColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            
            let dataSet1 = LineChartDataSet(values:lineChartEntry1, label: "Systolic")
            dataSet1.axisDependency = .left
            dataSet1.setColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.lineWidth = 3.0
            dataSet1.drawCirclesEnabled = true
            dataSet1.drawValuesEnabled = true
            dataSet1.setCircleColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.fillAlpha = 0.26
            dataSet1.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            dataSet1.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet1.drawCircleHoleEnabled = true
            
            let data = LineChartData(dataSets: [dataSet1, dataSet])
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 2:
            
            lineChart.xAxis.labelCount = 15
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 31
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgBPDiastolic), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry1.append(entry)
                }
            }
            if lineChartEntry.count == 0 || lineChartEntry1.count==0 {
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Diastolic")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.setCircleColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            
            let dataSet1 = LineChartDataSet(values:lineChartEntry1, label: "Systolic")
            dataSet1.axisDependency = .left
            dataSet1.setColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.lineWidth = 3.0
            dataSet1.drawCirclesEnabled = true
            dataSet1.drawValuesEnabled = true
            dataSet1.setCircleColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.fillAlpha = 0.26
            dataSet1.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            dataSet1.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet1.drawCircleHoleEnabled = true
            
            let data = LineChartData(dataSets: [dataSet1, dataSet])
            data.setValueTextColor(.red)
            lineChart.data = data
        case 3:
            
            lineChart.xAxis.labelCount = 12
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 12
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgBPDiastolic), let xValue = Double(data.monthNo) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
                
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.monthNo) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry1.append(entry)
                }
            }
            if lineChartEntry.count == 0 || lineChartEntry1.count==0 {
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Diastolic")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.setCircleColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            
            let dataSet1 = LineChartDataSet(values:lineChartEntry1, label: "Systolic")
            dataSet1.axisDependency = .left
            dataSet1.setColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.lineWidth = 3.0
            dataSet1.drawCirclesEnabled = true
            dataSet1.drawValuesEnabled = true
            dataSet1.setCircleColor(#colorLiteral(red: 0.5588079095, green: 0.8083131313, blue: 0.8444147706, alpha: 1))
            dataSet1.fillAlpha = 0.26
            dataSet1.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            dataSet1.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet1.drawCircleHoleEnabled = true
            
            let data = LineChartData(dataSets: [dataSet1, dataSet])
            data.setValueTextColor(.red)
            lineChart.data = data
        default:
            print("defalt case")
        }
    }
    
    func loadSystolicData(selectedIndex:Int){
        var lineChartEntry = [ChartDataEntry]()
        lineChart.clear()
        switch selectedIndex {
        case 0:
            lineChart.xAxis.valueFormatter = nil
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 24
            lineChart.xAxis.labelCount = 12
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.hour) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Daily")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 1:
            lineChart.xAxis.labelCount = 7
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 6
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "weekly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 2:
            
            lineChart.xAxis.labelCount = 15
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 31
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Monthly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
        case 3:
            
            lineChart.xAxis.labelCount = 12
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 12
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgBPSystolic), let xValue = Double(data.monthNo) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Yearly")
            let data = LineChartData(dataSet: dataSet)
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            data.setValueTextColor(.red)
            lineChart.data = data
        default:
            print("defalt case")
        }
    }
    
    func loadWeightData(selectedIndex:Int){
        lineChart.clear()
        var lineChartEntry = [ChartDataEntry]()
        //  let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        
        switch selectedIndex {
        case 0:
            lineChart.xAxis.valueFormatter = nil
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 24
            lineChart.xAxis.labelCount = 12
            
            //   lineChart.xAxis.granularityEnabled = true
            //barChart.xAxis.axisMinimum = 6
            
            for data in  patientCharDataModel.dailyChartData{
                if let  aveData = Double(data.avgWeight), let xValue = Double(data.hour) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Daily")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 1:
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = 6
            lineChart.xAxis.labelCount = 7
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.valueFormatter = CustomChartFormatter()
            
            for data in  patientCharDataModel.weeklyChartData{
                if let  aveData = Double(data.avgWeight), let xValue = Double(data.day) {
                    let entry = BarChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Weekly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
            
        case 2:
            
            lineChart.xAxis.labelCount = 15
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 31
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.monthlyChartData{
                if let  aveData = Double(data.avgWeight), let xValue = Double(data.day) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Monthly")
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            let data = LineChartData(dataSet: dataSet)
            data.setValueTextColor(.red)
            lineChart.data = data
        case 3:
            
            lineChart.xAxis.labelCount = 12
            lineChart.xAxis.forceLabelsEnabled = true
            lineChart.xAxis.granularityEnabled = true
            lineChart.xAxis.granularity = 1
            lineChart.xAxis.axisMinimum = 1
            lineChart.xAxis.axisMaximum = 12
            lineChart.xAxis.valueFormatter = nil
            
            for data in  patientCharDataModel.yearlyChartData{
                if let  aveData = Double(data.avgWeight), let xValue = Double(data.monthNo) {
                    let entry = ChartDataEntry(x: Double(xValue), y: Double(aveData))
                    lineChartEntry.append(entry)
                }
            }
            if lineChartEntry.count == 0{
                return
            }
            let dataSet = LineChartDataSet(values:lineChartEntry, label: "Yearly")
            let data = LineChartData(dataSet: dataSet)
            dataSet.axisDependency = .left
            dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
            dataSet.lineWidth = 3.0
            dataSet.drawCirclesEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.fillAlpha = 0.26
            dataSet.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            dataSet.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dataSet.drawCircleHoleEnabled = true
            data.setValueTextColor(.red)
            lineChart.data = data
        default:
            print("defalt case")
        }
    }
    
    
    @IBAction func segementControllAction(_ sender: UISegmentedControl) {
        selectedTimeInterVal = sender.selectedSegmentIndex
        loadChartAccourdingToSelectedCategoryAndTimeInterval(category: selectedCategory, timeInterVal: selectedTimeInterVal)
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setDataCount(_ count: Int, range: UInt32) {
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 60
        
        let from = now - (Double(count) / 2) * hourSeconds
        let to = now + (Double(count) / 2) * hourSeconds
        
        let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
            let y = arc4random_uniform(range) + 50
            return ChartDataEntry(x: x, y: Double(y))
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
        set1.lineWidth = 3.0
        set1.drawCirclesEnabled = true
        set1.drawValuesEnabled = true
        set1.fillAlpha = 0.26
        set1.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        set1.highlightColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        set1.drawCircleHoleEnabled = true
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        //   data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        lineChart.data = data
    }
    
    func barChartUpdate (barcodeSet: BarChartDataSet) {
        
        // Basic set up of plan chart
        
        //        let entry1 = BarChartDataEntry(x: 1.0, y: Double(50))
        //        let entry2 = BarChartDataEntry(x: 5.0, y: Double(44))
        //        let entry3 = BarChartDataEntry(x: 2.0, y: Double(20))
        //        let entry1 = BarChartDataEntry(x: 1.0, y: 50.0)
        //        let entry2 = BarChartDataEntry(x: 2.0, y: 20.0)
        //        let entry3 = BarChartDataEntry(x: 3.0, y: 30.0)
        //        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "Widgets Type")
        let data = BarChartData(dataSets: [barcodeSet])
        let dataSet = barcodeSet
        //   let data = barcodeData
        barChart.data = data
        // barChart.chartDescription?.text = "Type"
        
        // Color
        //  dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.setColor(#colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1))
        
        
        // Refresh chart with new data
        //    barChart.notifyDataSetChanged()
    }
    
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    //   var items = ["0", "1", "2", "3","4"]
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ChartTypeCollectionViewCell
        var chartDataModel = CharData()
        switch selectedTimeInterVal {
        case 0:
            chartDataModel = patientCharDataModel.dailyAvarageData
        case 1:
            chartDataModel = patientCharDataModel.weekAvarageData
        case 2:
            chartDataModel = patientCharDataModel.monthAvarageData
        case 3:
            chartDataModel = patientCharDataModel.yearAvarageData
        default:
            print("default  configuration")
        }
        
        switch indexPath.item {
        case 0:
            cell.typeName?.text = "Blood Pressure"
            cell.minMax?.text = String(format: "%.2f/%.2f", chartDataModel.avgBPSystolic.double ?? 0, chartDataModel.avgBPDiastolic.double ?? 0 )
            cell.unit?.text = "mmHg"
        case 1:
            cell.typeName?.text = "Heart Rate"
            cell.minMax?.text = String(format: "%.2f", chartDataModel.avgHeartRate.double ?? 0)
            cell.unit?.text = "BPM"
        case 2:
            cell.typeName?.text = "Step Count"
            cell.minMax?.text = String(format: "%.2f", chartDataModel.avgSteps.double ?? 0 )
            cell.unit?.text = "Steps (\(convertStepToKM(steps: (cell.minMax?.text)!))km)"
        case 3:
            cell.typeName?.text = "Weight"
            cell.minMax?.text = String(format: "%.2f", chartDataModel.avgWeight.double ?? 0 )
            cell.unit?.text = "KG"
        case 4:
            cell.typeName?.text = "Sleep Minutes"
            cell.minMax?.text = String(format: "%.2f", chartDataModel.avgSleepMinutes.double ?? 0 )
            cell.unit?.text = "In bed time"
            
        case 5:
            cell.typeName?.text = "Systolic"
            cell.minMax?.text = String(format: "%.2f", chartDataModel.avgBPSystolic.double ?? 0 )
            cell.unit?.text = "BPM"
        default:
            print("Default Item")
        }
        
        
        cell.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.contentView.layer.cornerRadius = 12.0
        cell.contentView.layer.masksToBounds = true;
        
        if indexPath.item == selectedCategory {
            cell.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        }
        
        
        return cell
    }
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let lastSelectedIndex = IndexPath(item: selectedCategory, section: 0)
        let lastCell = collectionView.cellForItem(at: lastSelectedIndex)
        lastCell?.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.368627451, blue: 0.4156862745, alpha: 1)
        
        selectedCategory = indexPath.item
        loadChartAccourdingToSelectedCategoryAndTimeInterval(category: selectedCategory, timeInterVal: selectedTimeInterVal)
        
        if indexPath.item == 2 || indexPath.item == 4{
            //  setuplineChar()
            barChart.isHidden = false
            lineChart.isHidden = true
        }else{
            //  setupBarChart()
            barChart.isHidden = true
            lineChart.isHidden = false
        }
        
        print("You selected cell #\(indexPath.item)!")
        // collectionView.reloadData()
        
    }
    
    
    
    func getDayNumber(day:String)->Int{
        var days = ["S", "M", "T", "W", "T", "F", "S"]
        return days.index(of: day)!
    }
}



public class CustomChartFormatter: NSObject, IAxisValueFormatter {
    
    var days = ["S", "M", "T", "W", "T", "F", "S"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dayInInteger = Int(value)
        if dayInInteger >= 0 && dayInInteger < 7{
            return days[dayInInteger]
        }else{
            return ""
        }
    }
    
}
