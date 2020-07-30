/**
 * @file
 * Implements indicator under MQL5.
 */

// Defines indicator properties.
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots 3
#property indicator_color1 DeepSkyBlue
#property indicator_color2 LimeGreen
#property indicator_color3 Red
#property indicator_width1 2
#property indicator_style2 STYLE_DOT
#property indicator_style3 STYLE_DOT
#property indicator_level1 50

// Includes EA31337 framework.
#include <EA31337-classes/Indicator.mqh>
#include <EA31337-classes/Indicators/Indi_MA.mqh>

// Defines macros.
#define Bars (Chart::iBars(_Symbol, _Period))

// Includes the main file.
#include "Indi_SVE_Bollinger_Bands.mq4"