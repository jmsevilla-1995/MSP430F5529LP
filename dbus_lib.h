/*
 * dbus_lib.h
 *
 *  Created on: 22 ene. 2022
 *      Author: juan_
 */

#ifndef DBUS_LIB_H_
#define DBUS_LIB_H_

void enviar_mensaje(char mensaje[]){
    int i = 0;
    while(mensaje[i] != '\0')
    {
        UCA1TXBUF = mensaje[i];
        while(UCA1STAT & UCBUSY);
            i++;
    }
    UCA1TXBUF = 0x0a;
    while(UCA1STAT & UCBUSY);
    UCA1TXBUF = 0x0d;
    while(UCA1STAT & UCBUSY);
    return;
}

void newline(void)
{
    while(!(UCA0IFG&UCTXIFG));  //waits for character
    UCA0TXBUF='\n';             //sets character to new line
    while(!(UCA0IFG&UCTXIFG));  //waits for character
    UCA0TXBUF='\r';             //sets character to carriage return
}

#endif /* DBUS_LIB_H_ */
