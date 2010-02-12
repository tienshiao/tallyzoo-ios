/*

 AdWhirlAdNetworkAdapter.h
 
 Copyright 2009 AdMob, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
*/

#import "AdWhirlDelegateProtocol.h"

typedef enum {
  AdWhirlAdNetworkTypeAdMob       = 1,
  AdWhirlAdNetworkTypeJumpTap     = 2,
  AdWhirlAdNetworkTypeVideoEgg    = 3,
  AdWhirlAdNetworkTypeMedialets   = 4,
  AdWhirlAdNetworkTypeLiveRail    = 5,
  AdWhirlAdNetworkTypeMillennial  = 6,
  AdWhirlAdNetworkTypeGreyStripe  = 7,
  AdWhirlAdNetworkTypeQuattro     = 8,
  AdWhirlAdNetworkTypeCustom      = 9,
  AdWhirlAdNetworkTypeAdWhirl10   = 10,
  AdWhirlAdNetworkTypeMobClix     = 11,
  AdWhirlAdNetworkTypeMdotM       = 12,
  AdWhirlAdNetworkTypeAdWhirl13   = 13,
  AdWhirlAdNetworkTypeGoogleAdSense = 14,
  AdWhirlAdNetworkTypeGoogleDoubleClick = 15,
  AdWhirlAdNetworkTypeGeneric     = 16,
} AdWhirlAdNetworkType;

@class AdWhirlView;
@class AdWhirlConfig;
@class AdWhirlAdNetworkConfig;

@interface AdWhirlAdNetworkAdapter : NSObject {
  id<AdWhirlDelegate> adWhirlDelegate;
  AdWhirlView *adWhirlView;
  AdWhirlConfig *adWhirlConfig;
  AdWhirlAdNetworkConfig *networkConfig;
  UIView *adNetworkView;
}

/**
 * Subclasses must implement +networkType to return an AdWhirlAdNetworkType enum.
 */
//+ (AdWhirlAdNetworkType)networkType;

/**
 * Subclasses must add itself to the AdWhirlAdNetworkRegistry. One way
 * to do so is to implement the +load function and register there.
 */
//+ (void)load;

/**
 * Default initializer. Subclasses do not need to override this method unless
 * they need to perform additional initialization. In which case, this
 * method must be called via the super keyword.
 */
- (id)initWithAdWhirlDelegate:(id<AdWhirlDelegate>)delegate
                         view:(AdWhirlView *)view
                       config:(AdWhirlConfig *)config
                networkConfig:(AdWhirlAdNetworkConfig *)netConf;

/**
 * Ask the Adapter to get an ad. This must be implemented by subclasses.
 */
- (void)getAd;

/**
 * Subclasses return YES to ask AdWhirlView to send metric requests to the
 * AdWhirl server for ad impressions. Default is YES.
 */
- (BOOL)shouldSendExMetric;

@property (nonatomic,assign) id<AdWhirlDelegate> adWhirlDelegate;
@property (nonatomic,assign) AdWhirlView *adWhirlView;
@property (nonatomic,retain) AdWhirlConfig *adWhirlConfig;
@property (nonatomic,retain) AdWhirlAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIView *adNetworkView;

@end
