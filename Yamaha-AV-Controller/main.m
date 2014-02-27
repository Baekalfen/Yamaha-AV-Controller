//
//  main.m
//  Yamaha-AV-Controller
//
//  Created by Mads Ynddal on 20/02/14.
//  Copyright (c) 2014 Mads Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communicator.h"

int main(int argc, const char * argv[])
{
	Communicator *c = [[Communicator alloc] init];
	
    NSString *host = @"192.168.0.102";
    
	c->host = [NSString stringWithFormat:@"http://%@",host];
	c->port = 80;
	
    NSString *pre = [NSString stringWithFormat:@"POST /YamahaRemoteControl/ctrl HTTP/1.1\r\nUser-Agent: AVcontrol/1.03 CFNetwork/485.12.30 Darwin/10.4.0\r\nContent-Type: text/xml; charset=UTF-8\r\nHost: %@\r\nContent-Length: 202\r\nExpect: 100-continue\r\nConnection: Keep-Alive\r\n\r\n<?xml version=\"1.0\" encoding=\"utf-8\"?><?xml version=\"1.0\" encoding=\"utf-8\"?>", host];
    
	[c setup];
	[c open];

    NSString *cmd;
    NSString *arg;
    if (argc>1){
        cmd = [NSString stringWithCString:argv[1] encoding:[NSString defaultCStringEncoding]];
        cmd = [cmd lowercaseString];
        arg = [NSString stringWithCString:argv[2] encoding:[NSString defaultCStringEncoding]];
        arg = [arg capitalizedString];
    }
    else{
        NSLog(@"Not enough arguments!");
        return 0;
    }
    
    [c writeOut:pre];
    if ([cmd isEqualToString:@"vol"] || [cmd isEqualToString:@"volume"]){
        [c writeOut:[NSString stringWithFormat:@"<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Volume><Lvl><Val>%@</Val><Exp>1</Exp><Unit>dB</Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>",[NSString stringWithFormat:@"-%@0",arg]]];
    }
    else if ([cmd isEqualToString:@"pwr"] || [cmd isEqualToString:@"power"]){
        if ([arg isEqualToString:@"Off"]){
            arg = @"Standby";
        }
        [c writeOut:[NSString stringWithFormat:@"<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Power_Control><Power>%@</Power></Power_Control></Main_Zone></YAMAHA_AV>",arg]];
    }
    else if ([cmd isEqualToString:@"pd"] || [cmd isEqualToString:@"puredirect"]){
        [c writeOut:[NSString stringWithFormat:@"<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Sound_Video><Pure_Direct><Mode>%@</Mode></Pure_Direct></Sound_Video></Main_Zone></YAMAHA_AV>\r\n\r\n",arg]];
    }
    else if ([cmd isEqualToString:@"m"] || [cmd isEqualToString:@"mute"]){
        [c writeOut:[NSString stringWithFormat:@"<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Volume><Mute>%@</Mute></Volume></Main_Zone></YAMAHA_AV>",arg]];
    }
    else if ([cmd isEqualToString:@"s"] || [cmd isEqualToString:@"scene"]){
        [c writeOut:[NSString stringWithFormat:@"<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Scene><Scene_Sel>Scene %@</Scene_Sel></Scene></Main_Zone></YAMAHA_AV>",arg]];
    }
    
	return 0;
}