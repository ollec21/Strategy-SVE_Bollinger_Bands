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
INPUT int Indi_SVE_Bollinger_Band_Shift = 0;                // Indicator Shift
// Strategy params.
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
INPUT int SVE_Bollinger_Bands_Shift = 0;                   // Strategy Shift (relative to the current bar, 0 - default)

// Structs.

// Defines struct with default user indicator values.
struct Indi_SVE_Bollinger_Bands_Params_Defaults : Indi_SVE_Bollinger_Bands_Params {
  Indi_SVE_Bollinger_Bands_Params_Defaults()
      : Indi_SVE_Bollinger_Bands_Params(::Indi_SVE_Bollinger_Band_TEMAPeriod, ::Indi_SVE_Bollinger_Band_SvePeriod,
                                        ::Indi_SVE_Bollinger_Band_BBUpDeviations,
                                        ::Indi_SVE_Bollinger_Band_BBDnDeviations,
                                        ::Indi_SVE_Bollinger_Band_DeviationsPeriod, ::Indi_SVE_Bollinger_Band_Shift) {}
} indi_svebbands_defaults;

// Defines struct with default user strategy values.
struct Stg_SVE_Bollinger_Bands_Params_Defaults : StgParams {
  Stg_SVE_Bollinger_Bands_Params_Defaults()
      : StgParams(::SVE_Bollinger_Bands_SignalOpenMethod, ::SVE_Bollinger_Bands_SignalOpenFilterMethod,
                  ::SVE_Bollinger_Bands_SignalOpenLevel, ::SVE_Bollinger_Bands_SignalOpenBoostMethod,
                  ::SVE_Bollinger_Bands_SignalCloseMethod, ::SVE_Bollinger_Bands_SignalCloseLevel,
                  ::SVE_Bollinger_Bands_PriceLimitMethod, ::SVE_Bollinger_Bands_PriceLimitLevel,
                  ::SVE_Bollinger_Bands_TickFilterMethod, ::SVE_Bollinger_Bands_MaxSpread,
                  ::SVE_Bollinger_Bands_Shift) {}
} stg_svebbands_defaults;

// Defines struct to store indicator and strategy params.
struct Stg_SVE_Bollinger_Bands_Params {
  Indi_SVE_Bollinger_Bands_Params iparams;
  StgParams sparams;

  // Struct constructors.
  Stg_SVE_Bollinger_Bands_Params(Indi_SVE_Bollinger_Bands_Params &_iparams, StgParams &_sparams)
      : iparams(indi_svebbands_defaults, _iparams.tf), sparams(stg_svebbands_defaults) {
    iparams = _iparams;
    sparams = _sparams;
  }
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
    Indi_SVE_Bollinger_Bands_Params _indi_params(indi_svebbands_defaults, _tf);
    StgParams _stg_params(stg_svebbands_defaults);
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Indi_SVE_Bollinger_Bands_Params>(_indi_params, _tf, indi_svebbands_m1, indi_svebbands_m5,
                                                     indi_svebbands_m15, indi_svebbands_m30, indi_svebbands_h1,
                                                     indi_svebbands_h4, indi_svebbands_h4);
      SetParamsByTf<StgParams>(_stg_params, _tf, stg_svebbands_m1, stg_svebbands_m5, stg_svebbands_m15,
                               stg_svebbands_m30, stg_svebbands_h1, stg_svebbands_h4, stg_svebbands_h4);
    }
    // Initialize indicator.
    _stg_params.SetIndicator(new Indi_SVE_Bollinger_Bands(_indi_params));
    // Initialize strategy parameters.
    _stg_params.GetLog().SetLevel(_log_level);
    _stg_params.SetMagicNo(_magic_no);
    _stg_params.SetTf(_tf, _Symbol);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_SVE_Bollinger_Bands(_stg_params, "SVE BB");
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
    if (!_result) {
      // Returns false when indicator data is not valid.
      return false;
    }
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // Buy signal.
        _result = _indi[CURR].value[SVE_BAND_MAIN] > _indi[CURR].value[SVE_BAND_UPPER];
        break;
      case ORDER_TYPE_SELL:
        // Sell signal.
        _result = _indi[CURR].value[SVE_BAND_MAIN] < _indi[CURR].value[SVE_BAND_LOWER];
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
