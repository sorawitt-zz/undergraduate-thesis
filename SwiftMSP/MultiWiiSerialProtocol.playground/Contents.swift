//
//  MultiWii.swift
//  MSPConf
//
//  Created by Sorawit on 10/16/17.
//  Copyright © 2017 Sorawit. All rights reserved.
//

import Foundation

class MultiWii {
    
    /* MultiWii Serial Protocol Message ID */
    
    let MSP_RAW_IMU:UInt16     =  101
    let MSP_MOTOR:UInt16       =  104
    let MSP_SET_MOTOR:UInt16   =  214
    let MSP_RC:UInt16          =  105
    let MSP_SET_RAW_RC:UInt16  =  200
    let MSP_RAW_GPS:UInt16     =  106
    let MSP_SET_RAW_GPS:UInt16 =  201
    let MSP_ALTITUDE:UInt16    =  109
    let MSP_ATTITUDE:UInt16    =  108
    
    
    
    func getMspSetRawRC(roll: UInt16, pitch: UInt16, yaw: UInt16, throttle: UInt16, aux1: UInt16, aux2: UInt16, aux3: UInt16, aux4: UInt16) -> [UInt16]{
        
        
        
        /* - -   Pack of Command  - - */
        // [ header,size,msgId,data,crc]
        
        let header1:UInt16 = 36 //$
        let header2:UInt16 = 77 //M
        let header3:UInt16 = 60 //<
        
        var checksum:UInt16 = 0
        
        var rc_roll_lsb: UInt16!
        var rc_pitch_lsb: UInt16!
        var rc_yaw_lsb: UInt16!
        var rc_throttle_lsb: UInt16!
        
        var rc_roll_msb: UInt16!
        var rc_pitch_msb: UInt16!
        var rc_yaw_msb: UInt16!
        var rc_throttle_msb: UInt16!
        
        let rc_aux1_lsb: UInt16!
        let rc_aux2_lsb: UInt16!
        let rc_aux3_lsb: UInt16!
        let rc_aux4_lsb: UInt16!
        
        let rc_aux1_msb: UInt16!
        let rc_aux2_msb: UInt16!
        let rc_aux3_msb: UInt16!
        let rc_aux4_msb: UInt16!
        
        
        let msgSize:UInt16 = 16 //size of command -> MSP_SET_RAW_RC
        let msgID:UInt16 =  MSP_SET_RAW_RC // message_id -> MSP_SET_RAW_RC == 200
        
        var command:[UInt16] = []
        
        /* calculate LSB and MSB of rc_value */
        
        rc_roll_lsb = roll & 0xFF
        rc_roll_msb = (roll >> 8) & 0xFF
        
        rc_pitch_lsb = pitch & 0xFF
        rc_pitch_msb = (pitch >> 8) & 0xFF
        
        rc_yaw_lsb = yaw & 0xFF
        rc_yaw_msb = (yaw >> 8) & 0xFF
        
        rc_throttle_lsb = throttle & 0xFF
        rc_throttle_msb = (throttle >> 8) & 0xFF
        
        rc_aux1_lsb = aux1 & 0xFF
        rc_aux1_msb = (aux1 >> 8) & 0xFF
        
        rc_aux2_lsb = aux2 & 0xFF
        rc_aux2_msb = (aux2 >> 8) & 0xFF
        
        rc_aux3_lsb = aux3 & 0xFF
        rc_aux3_msb = (aux3 >> 8) & 0xFF
        
        rc_aux4_lsb = aux4 & 0xFF
        rc_aux4_msb = (aux4 >> 8) & 0xFF
        
        /*  calculate checksum using XOR */
        checksum = msgSize ^ msgID
        
        checksum = checksum ^ rc_roll_lsb
        checksum = checksum ^ rc_roll_msb
        
        checksum = checksum ^ rc_pitch_lsb
        checksum = checksum ^ rc_pitch_msb
        
        checksum = checksum ^ rc_yaw_lsb
        checksum = checksum ^ rc_yaw_msb
        
        checksum = checksum ^ rc_throttle_lsb
        checksum = checksum ^ rc_throttle_msb
        
        checksum = checksum ^ rc_aux1_lsb
        checksum = checksum ^ rc_aux1_msb
        
        checksum = checksum ^ rc_aux2_lsb
        checksum = checksum ^ rc_aux2_msb
        
        checksum = checksum ^ rc_aux3_lsb
        checksum = checksum ^ rc_aux3_msb
        
        checksum = checksum ^ rc_aux4_lsb
        checksum = checksum ^ rc_aux4_msb
        
        /*  add data to command */
        
        command.append(header1)
        command.append(header2)
        command.append(header3)
        command.append(msgSize)
        command.append(msgID)
        command.append(rc_roll_lsb)
        command.append(rc_roll_msb)
        command.append(rc_pitch_lsb)
        command.append(rc_pitch_msb)
        command.append(rc_yaw_lsb)
        command.append(rc_yaw_msb)
        command.append(rc_throttle_lsb)
        command.append(rc_throttle_msb)
        command.append(rc_aux1_lsb)
        command.append(rc_aux1_msb)
        command.append(rc_aux2_lsb)
        command.append(rc_aux2_msb)
        command.append(rc_aux3_lsb)
        command.append(rc_aux3_msb)
        command.append(rc_aux4_lsb)
        command.append(rc_aux4_msb)
        command.append(checksum)
        
        return command
    }
}

var msp = MultiWii()
let cmd = msp.getMspSetRawRC(roll: 1500, pitch: 1500, yaw: 1500, throttle: 2000, aux1: 1000, aux2: 1000, aux3: 1000, aux4: 1000)

