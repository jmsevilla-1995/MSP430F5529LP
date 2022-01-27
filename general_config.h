/*
 * general_config.h
 *
 *  Created on: 22 ene. 2022
 *      Author: juan_
 */

#ifndef GENERAL_CONFIG_H_
#define GENERAL_CONFIG_H_

void conf_watchdog(){
    WDTCTL = WDTPW + WDTHOLD;   // stop watchdog timer
    return;
}


#endif /* GENERAL_CONFIG_H_ */
