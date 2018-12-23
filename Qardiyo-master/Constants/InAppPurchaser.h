


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "AppDelegate.h"



@interface InAppPurchaser : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProductsRequest *productsRequest;
    AppDelegate *appDelegate;
    int count;
    
    
}

- (void)purchaseItem: (NSString*)aStrItemID ;
- (void)restore;
-(void)afterSuccess;
@end
