#include <msp430.h> 
#include <dbus_lib.h>
#include <general_config.h>

/**
 * main.c
 */

void enviar_mensaje(char mensaje[]);

void conf_watchdog();

void newline(void);


void main(void)
{
    char msg[] = "Enviar mensaje!";
    char msg_resaltar[] = "#####################";
    char mensaje[] = "H";
    int estado = 0;
    int presionando = 1;
    int presionando_ant = 1;

    conf_watchdog();

    P4SEL |= 0x30;
    UCA1CTL1 |= UCSWRST;
    UCA1CTL1 |= UCSSEL_1;
    UCA1BR0 = 3;
    UCA1BR1 = 0x00;
    UCA1MCTL = 0x06;
    UCA1CTL0 = 0x00;
    UCA1CTL1 &= ~UCSWRST;

    UCA0CTL1 |= UCSWRST;                      // **Put state machine in reset**
    UCA0CTL1 |= UCSSEL_2;                     // SMCLK
    UCA0BR0 = 6;                              // 1MHz 9600 (see User's Guide)
    UCA0BR1 = 0;                              // 1MHz 9600
    UCA0MCTL = UCBRS_0 + UCBRF_13 + UCOS16;   // Modln UCBRSx=0, UCBRFx=0,

    UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI state machine**
    UCA0IE |= UCRXIE;                         // Enable USCI_A0 RX interrupt

    P1DIR = P1DIR | BIT0;
    P1SEL = P1SEL & ~BIT0;

    P2DIR = P2DIR & ~BIT1;
    P2SEL = P2SEL & ~BIT1;

    P2REN = P2REN | BIT1;
    P2OUT = P2OUT | BIT1;

    while(1)
    {
        if (P2IN & BIT1)
            presionando = 1;
        else
        {
            presionando = 0;
        }
        if (presionando != presionando_ant & presionando == 1 & estado == 0)
        {
            estado = 1;
        }
        presionando_ant = presionando;
        if (estado == 1)
        {
            estado = 0;
            P1OUT |= BIT0;
            enviar_mensaje(msg_resaltar);
            enviar_mensaje(msg);
            enviar_mensaje(msg_resaltar);
            enviar_mensaje(mensaje);
            enviar_mensaje(msg_resaltar);
        }
        else
        {
            P1OUT &= ~BIT0;
        }
    }
	
	return;
}




