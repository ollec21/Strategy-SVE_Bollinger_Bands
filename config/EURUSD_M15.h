/**
 * @file
 * Defines default strategy parameter values for the given timeframe.
 */

// Defines indicator's parameter values for the given pair symbol and timeframe.
struct Indi_SVE_Bollinger_Bands_Params_M15 : Indi_SVE_Bollinger_Bands_Params {
  Indi_SVE_Bollinger_Bands_Params_M15() : Indi_SVE_Bollinger_Bands_Params(indi_svebbands_defaults, PERIOD_M15) {
    applied_price = (ENUM_APPLIED_PRICE)0;
    ma_method = (ENUM_MA_METHOD)0;
    period = 0;
    shift = 0;
  }
} indi_svebbands_m15;

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SVE_Bollinger_Bands_Params_M15 : StgParams {
  // Struct constructor.
  Stg_SVE_Bollinger_Bands_Params_M15() : StgParams(stg_svebbands_defaults) {
    lot_size = 0;
    signal_open_method = -4;
    signal_open_filter = 0;
    signal_open_level = (float)0.0;
    signal_open_boost = 1;
    signal_close_method = 0;
    signal_close_level = (float)0.0;
    price_stop_method = 0;
    price_stop_level = (float)0.0;
    tick_filter_method = 1;
    max_spread = 0;
  }
} stg_svebbands_m15;
