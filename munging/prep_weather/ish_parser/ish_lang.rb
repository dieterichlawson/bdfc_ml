module ISHParser
    MAIN_FORMAT = '_4  i6    i5   s8      s4  sD6e3  D7e3   s5   i5   s5   s4  i3 ssD4e1si5   sssi6    sssD5e1 sD5e1 sD5e1 ss*'
    
    FORMATS = {
      'ADD' => '',
      # Liquid-Precipitation Occurrence
      #      AA101000095
      'AA#' => 'i2D4e1ss',
      # Liquid-precipitation Monthly total
      'AB#' => 'D5e1sss',
      # Precipitation Observation History
      'AC#' => 'sss',
      # Liquid-precipitation greatest amount in 24 hrs for the month
      'AD#' => 'D5e1 si4  i4  i4  s',
      # Liquid-precipitation number of days with specific amounts, for the month
      'AE#' => 'i2si2si2si2s',
      # Precipitation-estimated
      'AG#' => 'si3',
      'AH#' => 'i3 D4e1si6    s',
      'AI#' => 'i3 D4e1si6    s',
      'AJ#' => 'i4  ssD6e1  ss',
      'AK#' => 'i4  si2i2i2s',
      'AL#' => 'i2i3 ss',
      'AM#' => 'D4e1si2i2i2i2i2i2s',
      'AN#' => 'i3 D4e1ss',
      'AO#' => 'i2D4e1ss',
      'AP#' => 'D4e1ss',
      'AU#' => 'sss2ssss',
      'AW#' => 's2s',
      'AX#' => 's2si2s',
      'AY#' => 'ssi2s',
      'AZ#' => 'ssi2s',
      
      'CB#' => 'i2D6e1  ss',
      'CF#' => 'D4e1ss',
      'CG#' => 'D6e1  ss',
      'CH#' => 'i2D5e1 ssD4e1ss',
      'CI1' => 'D5e1 ssD5e1 ssD5e1 ssD5e1 ss',
      'CN1' => 'D4e1ssD4e1ssD4e1ss',
      'CN2' => 'D5e1 ss D5e1 ssi2ss',
      'CN3' => 'D6e1  ssD6e1  ss',
      'CN4' => 'ssssssD3e1ssD3e1ss',
      'CR#' => 'D5e3 ss',
      'CT#' => 'D5e1 ss',
      'CU#' => 'D5e1 ssD4e1ss', 
      'CV#' => 'D5e1 ssi4  ssD5e1 ssi4  ss',
      'CW#' => 'D5e1 ssD5e1 ss',
      'CX#' => 'D6e1  ssi4  ssi4  ssi4  ss',
      'CO1' => 'i2D3 ',
      'CO#' => 'i3 D5e1 ',
      
      'ED#' => 'i2si4  s',

      'GA#' => 's2si6    ss2s',
      'GD#' => 'ss2si6    ss',
      'GF#' => 's2s2ss2ss2si5   ss2ss2s',
      'GG#' => 's2si5   ss2ss2s',
      'GH#' => 'D5e1 ssD5e1 ssD5e1 ssD5e1 ss',
      'GJ#' => 'i4  s',
      'GK#' => 'i3 s',
      'GL#' => 'i5   s',
      'GM#' => 'i4  i4  s2si4  s2si4  s2si4  s',
      'GN#' => 'i4  i4  si4  si4  si4  si3 s',
      'GO#' => 'i4  i4  si4  si4  s',
      'GP#' => 'i4  i4  s2i3 i4  s2i3 i4  s2i3 ',
      'GQ#' => 'i4  D4e1sD4e1s',
      'GR#' => 'i4  i4  si4  s',
      
      'HL#' => 'D3e1s',

      'IA1' => 's2s',
      'IA2' => 'D3e1D5e1s',
      'IB1' => 'D5e1 ssD5e1 ssD5e1 ssD4e1ss',
      #STUFF
      'IB2' => 'D5e1 iiD4e1ii',
      'IC#' => 'i2i4  ssD3e2ssD4e1ssD4e1ss',

      'KA#' => 'D3e1sD5e1s',
      'KB#' => 'i3sD5e2 s',
      'KC#' => 'ssD5e1 s2s2s2s',
      'KD#' => 'i3 si4  s',
      'KE#' => 'i2si2si2si2s',
      'KF#' => 'D5e1 i',
      'KG#' => 'i3 sD5e2 ss',

      'MA#' => 'D5e1 sD5e1 s',
      'MD#' => 'ssD3e1sD4e1s',
      'ME#' => 'si4  s',
      'MF#' => 'D5e1 sD5e1 s',
      'MG#' => 'D5e1 sD5e1 s',
      'MH#' => 'D5e1 sD5e1 s',
      'MK#' => 'D5e1 s6    sD5e1 s6    s',
      'MV#' => 's2s',
      'MW#' => 's2s',

      'OA#' => 'si2D4e1s',
      'OB#' => 'i3 D4e1iii3 iiD5e2 iiD5e2 ii',
      'OC#' => 'D4e1s',
      'OE#' => 'si2D5e2 D3e0D4e1s',
      
      'RH#' => 'D3e0 sD3e0 ss',
      
      'SA#' => 'D4e1s',
      'ST#' => 'sD5e1 sD4e1ss2sis',
      
      'UA#' => 'sD2e0D3e1ss2s',
      'UG#' => 'D2e0D3e1D3e0s',

      'WA#' => 'sD3e1ss',
      'WD#' => 's2i3 s2ssss2si3 i3 s',
      'WG#' => 's2i2s2s2s2s',
      'REM' => '',
      'SYN' => 'REM',
      'AWY' => 'REM',
      'MET' => 'REM',
      'SOD' => 'REM',
      'SOM' => 'REM',
      'HPD' => 'REM',

      'EQD' => '',
      'Q##' => 's6    ss6    ',
      'P##' => 's6    ss6    ',
      'R##' => 's6    ss6    ',
      'N##' => 's6    ss6    ',
      'QNN' => 's*',
    }
end
