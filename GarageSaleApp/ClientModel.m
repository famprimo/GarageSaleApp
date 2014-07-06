//
//  ClientModel.m
//  GarageSale
//
//  Created by Federico Amprimo on 17/05/14.
//  Copyright (c) 2014 Federico Amprimo. All rights reserved.
//

#import "ClientModel.h"

@implementation ClientModel

- (NSMutableArray*)getClients:(NSMutableArray*)clientList
{
    // Array to hold the listing data
    NSMutableArray *clients = [[NSMutableArray alloc] init];
    
    // Create client #1
    Client *tempClient = [[Client alloc] init];
    tempClient.client_id = @"00001";
    tempClient.name = @"Georghette";
    tempClient.last_name = @"Juliette Sutta";
    tempClient.sex = @"F";
    tempClient.zone = @"San Isidro";
    tempClient.address = @"Camino Real 234 Dpto 102";
    tempClient.phone1 = @"98-133-1313";
    tempClient.phone2 = @"443-2414";
    tempClient.phone3 = @"";
    tempClient.email = @"georghette@hotmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/georghette";
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpa1/t1.0-1/p160x160/10432499_10154193269290034_3773311256858868392_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #1 to the array
    [clients addObject:tempClient];
    
    // Create client #2
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00002";
    tempClient.name = @"Natalia";
    tempClient.last_name = @"Gallardo";
    tempClient.sex = @"F";
    tempClient.zone = @"Surco";
    tempClient.address = @"Av. Benavides 3213";
    tempClient.phone1 = @"97-123-5113";
    tempClient.phone2 = @"225-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"ngallardo@hotmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/natalia.gallardo.16547";
    tempClient.picture_link = @"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xap1/t1.0-9/10177352_10152306607879355_3463040953093391515_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #2 to the array
    [clients addObject:tempClient];
    
    // Create client #3
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00003";
    tempClient.name = @"Melisa";
    tempClient.last_name = @"Celi";
    tempClient.sex = @"F";
    tempClient.zone = @"Miraflores";
    tempClient.address = @"Av. Pardo 413";
    tempClient.phone1 = @"98-233-5113";
    tempClient.phone2 = @"444-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"mceli@hotmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/melisa.celi.1";
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t1.0-1/p160x160/10343013_10152545434713487_289713323910298441_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #3 to the array
    [clients addObject:tempClient];
 
    // Create client #4
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00004";
    tempClient.name = @"Amparo";
    tempClient.last_name = @"Gonzalez";
    tempClient.sex = @"F";
    tempClient.zone = @"San Isidro";
    tempClient.address = @"Barcelona 433";
    tempClient.phone1 = @"97-233-1513";
    tempClient.phone2 = @"222-1515";
    tempClient.phone3 = @"";
    tempClient.email = @"agonzalez@hotmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/amparo.gonzalez.946";
    tempClient.picture_link = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/t1.0-1/c7.0.160.160/p160x160/65036_10151780886293183_681281220_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #4 to the array
    [clients addObject:tempClient];

    // Create client #5
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00005";
    tempClient.name = @"Ivan";
    tempClient.last_name = @"Rosado";
    tempClient.sex = @"M";
    tempClient.zone = @"Magdalena";
    tempClient.address = @"La Mar 414";
    tempClient.phone1 = @"98-589-4819";
    tempClient.phone2 = @"445-2566";
    tempClient.phone3 = @"";
    tempClient.email = @"irosado@hotmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/ivan.rosado.963";
    tempClient.picture_link = @"https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xaf1/t1.0-9/1796525_10152246429229306_801627707_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #5 to the array
    [clients addObject:tempClient];

    // Create client #6
    tempClient = [[Client alloc] init];
    tempClient.client_id = @"00006";
    tempClient.name = @"Mily";
    tempClient.last_name = @"de la Cruz";
    tempClient.sex = @"F";
    tempClient.zone = @"Surco";
    tempClient.address = @"La Castellana 2342";
    tempClient.phone1 = @"99-144-1515";
    tempClient.phone2 = @"725-2666";
    tempClient.phone3 = @"";
    tempClient.email = @"mdelacruz@gmail.com";
    tempClient.preference = @"F";
    tempClient.facebook_id = @"https://www.facebook.com/mily.delacruz.90";
    tempClient.picture_link = @"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-prn2/t1.0-9/534197_483266975032862_774796863_n.jpg";
    tempClient.picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempClient.picture_link]];
    tempClient.notes = @"XXXX";
    tempClient.agent_id = @"00001";
    
    // Add client #6 to the array
    [clients addObject:tempClient];

    // Return the producct array as the return value
    return clients;
}

@end
