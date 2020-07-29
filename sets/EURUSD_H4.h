// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_SVE_Bollinger_Bands_EURUSD_H4_Params : Stg_SVE_Bollinger_Bands_Params {
  Stg_SVE_Bollinger_Bands_EURUSD_H4_Params() {
    SVE_Bollinger_Bands_LotSize = lot_size = 0;
    SVE_Bollinger_Bands_Shift = 0;
    SVE_Bollinger_Bands_SignalOpenMethod = signal_open_method = 0;
    SVE_Bollinger_Bands_SignalOpenFilterMethod = signal_open_filter = 1;
    SVE_Bollinger_Bands_SignalOpenLevel = signal_open_level = 0;
    SVE_Bollinger_Bands_SignalOpenBoostMethod = signal_open_boost = 0;
    SVE_Bollinger_Bands_SignalCloseMethod = signal_close_method = 0;
    SVE_Bollinger_Bands_SignalCloseLevel = signal_close_level = 0;
    SVE_Bollinger_Bands_PriceLimitMethod = price_limit_method = 0;
    SVE_Bollinger_Bands_PriceLimitLevel = price_limit_level = 2;
    SVE_Bollinger_Bands_TickFilterMethod = tick_filter_method = 1;
    SVE_Bollinger_Bands_MaxSpread = max_spread = 0;
  }
} stg_svebbands_h4;
