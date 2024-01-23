//
//  Network.h
//  JoyStick
//
//  Created by TSOA2 on 1/22/24.
//

#ifndef NETWORK_H
#define NETWORK_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>

#define DEFAULT_PORT (7100)
#define MAX_BUF_SIZE (128)

int init_socket(const char *ip_address);
void send_data(double x, double y);

#endif // NETWORK_H
