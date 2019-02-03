//
//  HealthkitQuery.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-31.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import HealthKit

class HealthkitQuery{
    
    class func queryData(completion: @escaping ([DeviceData]?, Error?) -> Swift.Void){
        
        var sampleStepOut = [HKQuantitySample]()
        var sampleHeartRate = [HKQuantitySample]()
        var sampleHeight = [HKQuantitySample]()
        var sampleWeight = [HKQuantitySample]()
        var sampleSleep = [HKCategorySample]()
        
        let group = DispatchGroup()

        // Query Step Count
        group.enter()
        guard let sampeTypeStepCount = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        queryInfo(for: sampeTypeStepCount, completion: {
            (samples, error) in
            
            guard let samples = samples else {
                if let error = error {
                    print(error)
                    completion(nil,error)
                }
                return
            }
            
            sampleStepOut = removeDuplicates(source: samples)

            group.leave()
        })
        
        // Query Heart Rate
        group.enter()

        guard let sampeTypeHeartRate = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            print("Hear tRate Sample Type is no longer available in HealthKit")
            return
        }
        
        queryInfo(for: sampeTypeHeartRate, completion: {
            (samples, error) in
            
            guard let samples = samples else {
                if let error = error {
                    print(error)
                    completion(nil,error)
                }
                return
            }
            
            sampleHeartRate = removeDuplicates(source: samples)
            group.leave()
        })

        // Query Height
        group.enter()
        guard let sampeTypeHeight = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Hear tRate Sample Type is no longer available in HealthKit")
            return
        }
        
        queryInfo(for: sampeTypeHeight, completion: {
            (samples, error) in
            
            guard let samples = samples else {
                if let error = error {
                    print(error)
                    completion(nil,error)
                }
                return
            }
            sampleHeight = removeDuplicates(source: samples)
            group.leave()
        })

        // Query Weight
        group.enter()

        guard let sampeTypeBodyMass = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Hear tRate Sample Type is no longer available in HealthKit")
            return
        }
        
        queryInfo(for: sampeTypeBodyMass, completion: {
            (samples, error) in
            
            guard let samples = samples else {
                if let error = error {
                    print(error)
                    completion(nil,error)
                }
                return
            }
            
            sampleWeight = removeDuplicates(source: samples)
            group.leave()
        })
        
        // Query sleep
        group.enter()

        guard let sampeTypeSleep = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            print("Sleep Sample Type is no longer available in HealthKit")
            return
        }
        
        queryInfoCategory(for: sampeTypeSleep, completion: {
            (samples, error) in
            
            guard let samples = samples else {
                if let error = error {
                    print(error)
                    completion(nil,error)
                }
                return
            }
            sampleSleep = removeDuplicates(source: samples)

            group.leave()
        })
        
        // when finish thread
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            var arrayDevice = [DeviceData]()
            // add step count
            for sample in sampleStepOut{
                let deviceData = DeviceData()
                deviceData.BundleID = sample.sourceRevision.source.bundleIdentifier
                deviceData.DeviceName = sample.device?.name ?? "iPhone"
                deviceData.SourceName = sample.sourceRevision.source.name
                deviceData.StepCount = sample.quantity.doubleValue(for: HKUnit.count())
                arrayDevice.append(deviceData)
            }

            // add heart rate
            for sample in sampleHeartRate {
                if let result = arrayDevice.first(where: {$0.BundleID == sample.sourceRevision.source.bundleIdentifier}){
                    result.HeartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                }else{
                    let deviceData = DeviceData()
                    deviceData.BundleID = sample.sourceRevision.source.bundleIdentifier
                    deviceData.DeviceName = sample.device?.name ?? "iPhone"
                    deviceData.SourceName = sample.sourceRevision.source.name
                    deviceData.HeartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    arrayDevice.append(deviceData)
                }
            }

            // add Height
            for sample in sampleHeight {
                if let result = arrayDevice.first(where: {$0.BundleID == sample.sourceRevision.source.bundleIdentifier}){
                    result.Height = sample.quantity.doubleValue(for: HKUnit.foot())
                }else{
                    let deviceData = DeviceData()
                    deviceData.BundleID = sample.sourceRevision.source.bundleIdentifier
                    deviceData.DeviceName = sample.device?.name ?? "iPhone"
                    deviceData.SourceName = sample.sourceRevision.source.name
                    deviceData.Height = sample.quantity.doubleValue(for: HKUnit.foot())
                    arrayDevice.append(deviceData)
                }
            }

            // add Height
            for sample in sampleWeight {
                if let result = arrayDevice.first(where: {$0.BundleID == sample.sourceRevision.source.bundleIdentifier}){
                    result.Weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                }else{
                    let deviceData = DeviceData()
                    deviceData.BundleID = sample.sourceRevision.source.bundleIdentifier
                    deviceData.DeviceName = sample.device?.name ?? "iPhone"
                    deviceData.SourceName = sample.sourceRevision.source.name
                    deviceData.Weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                    arrayDevice.append(deviceData)
                }
            }
            
            // add Sleep
            for sample in sampleSleep {
                if let result = arrayDevice.first(where: {$0.BundleID == sample.sourceRevision.source.bundleIdentifier}){
                    result.Sleep = minutes(fromDate: sample.startDate, toDate: sample.endDate)
                }else{
                    let deviceData = DeviceData()
                    deviceData.BundleID = sample.sourceRevision.source.bundleIdentifier
                    deviceData.DeviceName = sample.device?.name ?? "iPhone"
                    deviceData.SourceName = sample.sourceRevision.source.name
                    deviceData.Sleep = minutes(fromDate: sample.startDate, toDate: sample.endDate)
                    arrayDevice.append(deviceData)
                }
            }

            completion(arrayDevice,nil)
        }

    }
    
    class   func minutes(fromDate: Date, toDate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute ?? 0
    }
    
    class func queryInfo(for sampleType: HKSampleType, completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void){

        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        let limit = 0

        
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor],
                                        resultsHandler: {
                                            (query,samples,error) in
     
                                            DispatchQueue.main.async {
                                                if let samples = samples as? [HKQuantitySample] {
                                                    completion(samples, error)
                                                }else{
                                                    completion(nil, error)
                                                }
                                            }
        })
    
        HKHealthStore().execute(sampleQuery)
    }

    class func queryInfoCategory(for sampleType: HKSampleType, completion: @escaping ([HKCategorySample]?, Error?) -> Swift.Void){
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                              end: Date(),
                                                              options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        let limit = 0
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: mostRecentPredicate,
                                        limit: limit,
                                        sortDescriptors: [sortDescriptor],
                                        resultsHandler: {
                                            (query,samples,error) in
                                            
                                            DispatchQueue.main.async {
                                                if let samples = samples as? [HKCategorySample] {
                                                    completion(samples, error)
                                                }else{
                                                    completion(nil, error)
                                                }
                                            }
        })
        
        HKHealthStore().execute(sampleQuery)
    }
    
    class func removeDuplicates(source sources:[HKQuantitySample]) -> [HKQuantitySample] {
        var results = [HKQuantitySample]()
        
        for source in sources {
            var count = 0
            for result in results{
                if source.sourceRevision.source.bundleIdentifier == result.sourceRevision.source.bundleIdentifier {
                    count += 1
                }
            }
            if count == 0{
                results.append(source)
            }
        }
        
        return results
    }

    class func removeDuplicates(source sources:[HKCategorySample]) -> [HKCategorySample] {
        var results = [HKCategorySample]()
        
        for source in sources {
            var count = 0
            for result in results{
                if source.sourceRevision.source.bundleIdentifier == result.sourceRevision.source.bundleIdentifier {
                    count += 1
                }
            }
            if count == 0{
                results.append(source)
            }
        }
        
        return results
    }


    class func retrieveSleepAnalysis() {
        
 
        
        

        
//        // first, we define the object type we want
//        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
//            
//            
//            // we create our query with a block completion to execute
//            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
//                
//                if error != nil {
//                    
//                    // something happened
//                    return
//                    
//                }
//                
//                if let result = tmpResult {
//                    let source = removeDuplicates(source: tmpResult)
//                    debugPrint(source)
////                    // do something with my data
////                    for item in result {
////                        if let sample = item as? HKCategorySample {
////                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
////                            print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
////                            print("sample: \(sample)")
////                        }
////                    }
//                }
//            }
//            
//            // finally, we execute our query
//            HKHealthStore().execute(query)
//        }
    }
}


//        let sampleType =
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//
//        let query = HKSourceQuery(sampleType: sampleType!, samplePredicate: nil) {
//            query, sources, error in
//
//            if error != nil {
//
//                // Perform Proper Error Handling Here...
//                print("*** An error occured while gathering the sources for step date. \(String(describing: error?.localizedDescription)) ***")
//                completion(nil,error)
//            }else{
//                var arraySource = [HKSource]()
//
//                for object in sources! {
//                    arraySource.append(object)
//                    debugPrint(object.description)
//                }
//                completion(arraySource,error)
//            }
//        }
//
//        HKHealthStore().execute(query)
