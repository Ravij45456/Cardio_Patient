//
//  HealthkitSetup.swift
//  QardiyoHF
//
//  Created by Duy Pham on 2017-08-31.
//  Copyright © 2017 Vog Calgary App Developer Inc. All rights reserved.
//

import HealthKit

class HealthkitSetup {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let sleep = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
            let step = HKObjectType.quantityType(forIdentifier: .stepCount)else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [heartRate,
                                                       height,
                                                       bodyMass,
                                                       step,
                                                       sleep,
                                                       HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: nil,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
}
