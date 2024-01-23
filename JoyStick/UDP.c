//
//  UDP.c
//  JoyStick
//
//  Created by TSOA2 on 1/22/24.
//

// Also thank you Xcode for deleting my C code 3 different times 😘

#include "UDP.h"

static int sock = -1;
static int is_big_endian = 0;
static struct sockaddr_in settings;

static void close_socket(void)
{
    if (sock != -1) {
        close(sock);
    }
    
    sock = -1;
}

static void check_endian(void)
{
    uint16_t number = 0x0100;
    is_big_endian = (int) *(uint8_t *) &number;
}

static void encode_double(double x, uint8_t buf[sizeof(double)])
{
    if (!is_big_endian) {
        for (size_t i = 0; i < sizeof(double); i++) {
            buf[i] = ((uint8_t *) &x)[sizeof(double) - i - 1];
        }
        return ;
    }

    memcpy(buf, &x, sizeof(double));
}

int init_socket(const char *ip_address)
{
    close_socket();
    check_endian();
    
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        sock = -1;
        return -1;
    }
   
    if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int)) < 0) {
        close_socket();
        return -2;
    }

    if (setsockopt(sock, SOL_SOCKET, SO_REUSEPORT, &(int){1}, sizeof(int)) < 0) {
        close_socket();
        return -3;
    }

    settings.sin_family = AF_INET;
    settings.sin_port = htons(DEFAULT_PORT);
    settings.sin_addr.s_addr = inet_addr(ip_address);

    return 0;
}

void send_data(double x, double y)
{
    uint8_t buffer[MAX_BUF_SIZE] = {0};
    encode_double(x, &buffer[0 * sizeof(double)]);
    encode_double(y, &buffer[1 * sizeof(double)]);
    
    (void) sendto(sock, buffer, sizeof(double) * 2, 0, (struct sockaddr *) &settings, sizeof(settings));
}
