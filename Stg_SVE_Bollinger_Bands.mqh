/**
 * @file
 * Implements strategy based on the SVE Bollinger Bands indicator.
 */

// Includes.
#include <EA31337-classes/Strategy.mqh>
#include "Indi_SVE_Bollinger_Bands.mqh"

// User input params.
INPUT string __SVE_Bollinger_Bands_Parameters__ =
    "-- SVE Bollinger Bands strategy params --";  // >>> SVE Bollinger Bands <<<
INPUT float SVE_Bollinger_Bands_LotSize = 0;      // Lot size
// Indicators params.
INPUT int Indi_SVE_Bollinger_Band_TEMAPeriod = 8;           // TEMA Period
INPUT int Indi_SVE_Bollinger_Band_SvePeriod = 18;           // SVE Period
INPUT double Indi_SVE_Bollinger_Band_BBUpDeviations = 1.6;  // BB Up Deviation
INPUT double Indi_SVE_Bollinger_Band_BBDnDeviations = 1.6;  // BB Down Deviation
INPUT int Indi_SVE_Bollinger_Band_DeviationsPeriod = 63;    // Deviations Period
INPUT int Indi_SVE_Bollinger_Band_Shift = 0;                // Shift
// Strategy params.
INPUT int SVE_Bollinger_Bands_Shift = 0;                   // Shift (relative to the current bar, 0 - default)
INPUT int SVE_Bollinger_Bands_SignalOpenMethod = 0;        // Signal open method
INPUT int SVE_Bollinger_Bands_SignalOpenFilterMethod = 0;  // Signal open filter method
INPUT float SVE_Bollinger_Bands_SignalOpenLevel = 0;       // Signal open level
INPUT int SVE_Bollinger_Bands_SignalOpenBoostMethod = 0;   // Signal open boost method
INPUT int SVE_Bollinger_Bands_SignalCloseMethod = 0;       // Signal close method
INPUT float SVE_Bollinger_Bands_SignalCloseLevel = 0;      // Signal close level
INPUT int SVE_Bollinger_Bands_PriceLimitMethod = 0;        // Price limit method
INPUT float SVE_Bollinger_Bands_PriceLimitLevel = 2;       // Price limit level
INPUT int SVE_Bollinger_Bands_TickFilterMethod = 0;        // Tick filter method
INPUT float SVE_Bollinger_Bands_MaxSpread = 2.0;           // Max spread to trade (in pips)

// Struct to define strategy parameters to override.
struct Stg_SVE_Bollinger_Bands_Params : StgParams {
  float SVE_Bollinger_Bands_LotSize;
  int SVE_Bollinger_Bands_Shift;
  int SVE_Bollinger_Bands_SignalOpenMethod;
  int SVE_Bollinger_Bands_SignalOpenFilterMethod;
  float SVE_Bollinger_Bands_SignalOpenLevel;
  int SVE_Bollinger_Bands_SignalOpenBoostMethod;
  int SVE_Bollinger_Bands_SignalCloseMethod;
  float SVE_Bollinger_Bands_SignalCloseLevel;
  int SVE_Bollinger_Bands_PriceLimitMethod;
  float SVE_Bollinger_Bands_PriceLimitLevel;
  int SVE_Bollinger_Bands_TickFilterMethod;
  float SVE_Bollinger_Bands_MaxSpread;

  // Constructor: Set default param values.
  Stg_SVE_Bollinger_Bands_Params(Trade *_trade = NULL, Indicator *_data = NULL, Strategy *_sl = NULL,
                                 Strategy *_tp = NULL)
      : StgParams(_trade, _data, _sl, _tp),
        SVE_Bollinger_Bands_LotSize(::SVE_Bollinger_Bands_LotSize),
        SVE_Bollinger_Bands_Shift(::SVE_Bollinger_Bands_Shift),
        SVE_Bollinger_Bands_SignalOpenMethod(::SVE_Bollinger_Bands_SignalOpenMethod),
        SVE_Bollinger_Bands_SignalOpenFilterMethod(::SVE_Bollinger_Bands_SignalOpenFilterMethod),
        SVE_Bollinger_Bands_SignalOpenLevel(::SVE_Bollinger_Bands_SignalOpenLevel),
        SVE_Bollinger_Bands_SignalOpenBoostMethod(::SVE_Bollinger_Bands_SignalOpenBoostMethod),
        SVE_Bollinger_Bands_SignalCloseMethod(::SVE_Bollinger_Bands_SignalCloseMethod),
        SVE_Bollinger_Bands_SignalCloseLevel(::SVE_Bollinger_Bands_SignalCloseLevel),
        SVE_Bollinger_Bands_PriceLimitMethod(::SVE_Bollinger_Bands_PriceLimitMethod),
        SVE_Bollinger_Bands_PriceLimitLevel(::SVE_Bollinger_Bands_PriceLimitLevel),
        SVE_Bollinger_Bands_TickFilterMethod(::SVE_Bollinger_Bands_TickFilterMethod),
        SVE_Bollinger_Bands_MaxSpread(::SVE_Bollinger_Bands_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_SVE_Bollinger_Bands : public Strategy {
 public:
  Stg_SVE_Bollinger_Bands(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_SVE_Bollinger_Bands *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL,
                                       ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_SVE_Bollinger_Bands_Params _stg_params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_SVE_Bollinger_Bands_Params>(_stg_params, _tf, stg_svebbands_m1, stg_svebbands_m5,
                                                    stg_svebbands_m15, stg_svebbands_m30, stg_svebbands_h1,
                                                    stg_svebbands_h4, stg_svebbands_h4);
    }
    // Initialize strategy parameters.
    // TBSTIndiParams svebbands_params(_tf);
    _stg_params.GetLog().SetLevel(_log_level);
    //_stg_params.SetIndicator(new Indi_SVE_Bollinger_Bands(svebbands_params));
    _stg_params.SetMagicNo(_magic_no);
    _stg_params.SetTf(_tf, _Symbol);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_SVE_Bollinger_Bands(_stg_params, "SVE_Bollinger_Bands");
    _stg_params.SetStops(_strat, _strat);
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f) {
    Indicator *_indi = Data();
    bool _is_valid = _indi[CURR].IsValid();
    bool _result = _is_valid;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        break;
    }
    return _result;
  }

  /**
   * Gets price limit value for profit take or stop loss.
   */
  float PriceLimit(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, float _level = 0.0f) {
    // Indicator *_indi = Data();
    double _trail = _level * Market().GetPipSize();
    // int _bar_count = (int)_level * 10;
    int _direction = Order::OrderDirection(_cmd, _mode);
    double _default_value = Market().GetCloseOffer(_cmd) + _trail * _method * _direction;
    double _result = _default_value;
    // ENUM_APPLIED_PRICE _ap = _direction > 0 ? PRICE_HIGH : PRICE_LOW;
    switch (_method) {
      case 1:
        // Trailing stop here.
        break;
    }
    return (float)_result;
  }
};
