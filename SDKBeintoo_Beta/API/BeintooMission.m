/*******************************************************************************
 * Copyright 2011 Beintoo - author fmessina@beintoo.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

#import "BeintooMission.h"
#import "Beintoo.h"

@implementation BeintooMission

@synthesize delegate, parser, callingDelegate;

-(id)init
{
	if (self = [super init])
	{
        parser = [[Parser alloc] init];
		parser.delegate = self;
		
		rest_resource = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/mission",[Beintoo getRestBaseUrl]]];
	}
    return self;
}


- (NSString *)restResource
{
	return rest_resource;
}

#pragma mark -
#pragma mark Public API

+ (void)getMission
{
    NSString *lastMissionTimestamp = [Beintoo getMissionTimestamp];
    NSInteger hoursFromLastTs      = [BeintooDevice elapsedHoursSinceTimestamp:lastMissionTimestamp];

    if (hoursFromLastTs < HOURS_TO_SHOW_MISSION) {  // 24 hours 
        return;  // less than 24 hours, we return. no mission to be retrieved
    }
    
    [Beintoo setMissionTimestamp:[BeintooDevice getFormattedTimestampNow]];
    /*CLLocation *loc	 = [Beintoo getUserLocation];
    BeintooMission *missionService = [Beintoo beintooMissionService];
    
    NSString *res;
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey],@"apikey",
                            [BeintooDevice getUDID],@"deviceUUID", nil];
    
    if (loc == nil || (loc.coordinate.latitude <= 0.01f && loc.coordinate.latitude >= -0.01f) 
		|| (loc.coordinate.longitude <= 0.01f && loc.coordinate.longitude >= -0.01f)) {
		res = [NSString stringWithFormat:@"%@",[missionService restResource]];
	}
	else
		res	= [NSString stringWithFormat:@"%@?latitude=%f&longitude=%f&radius=%f",
               [missionService restResource],loc.coordinate.latitude,loc.coordinate.longitude,loc.horizontalAccuracy];
    
    [missionService.parser parsePageAtUrl:res withHeaders:params fromCaller:MISSION_GET_CALLER_ID];*/
}

+ (void)refuseMission
{
    /*BeintooMission *missionService = [Beintoo beintooMissionService];
    NSString *res = [NSString stringWithFormat:@"%@/refuse/",[missionService restResource]];

	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Beintoo getApiKey],@"apikey",
                            [BeintooDevice getUDID],@"deviceUUID", nil];
        
    [missionService.parser parsePageAtUrl:res withHeaders:params fromCaller:MISSION_REFUSE_CALLER_ID]*/;
}

#pragma mark -
#pragma mark Parser Delegate

- (void)didFinishToParsewithResult:(NSDictionary *)result forCaller:(NSInteger)callerID
{
	switch (callerID){
		case MISSION_GET_CALLER_ID:{
            
            if ([result objectForKey:@"messageID"]) {
                // An error occurred. a notification is sent to the main delegate
                //[Beintoo notifyRetrievedMisionErrorOnMainDelegateWithMission:result];
                return;
            }
            
            // ********** HERE TO SHOW THE BEINTOO MISSION VIEW! ********
            /* if(isNew == 1)
             * SHOW "here is your mission of the week"
             * else
             * SHOW "status of your mission"
             */
            [Beintoo setLastRetrievedMission:result];
            //[Beintoo launchMission];
            
           // [Beintoo notifyRetrievedMisionOnMainDelegateWithMission:result];
		}
			break;
            
        case MISSION_REFUSE_CALLER_ID:{
        }
			break;
            
        default:{
			//statements
		}
			break;
	}	
}

#pragma mark -
#pragma mark Class Methods

+ (void)setMissionDelegate:(id)_caller
{
	/*BeintooMission *missionService = [Beintoo beintooMissionService];
	missionService.callingDelegate = _caller;*/
}

- (void)dealloc
{
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
	[parser release];
	[rest_resource release];
    [super dealloc];
#endif
    
}

@end
