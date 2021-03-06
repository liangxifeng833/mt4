//+------------------------------------------------------------------+
//|                                                      5script.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      //当前买价
      double a = Ask;
      //当前卖价
      double b = Bid;
      //获取英镑兑美元的买价
      double c = MarketInfo("GBPUSD",MODE_ASK);
      //获取英镑兑美元的卖价
      double d = MarketInfo("GBPUSD",MODE_BID);
      //获取0号（最新）K线的开盘价，最高价，最低价，收盘价
      double op = Open[0];
      double hp = High[0];
      double lp = Low[0];
      double cp = Close[0];
      
      //模式使用脚本或EA，先选择好某个货币对的K线图，然后选择时间周期，最后拖入该图中。
      //如果想在本周期K中获取15分钟图0号序列K线图的开盘价，NULL表示当前货币对
      double op15m = iOpen(NULL,15,0);
      //获取英镑兑美元1分钟图的第3号K线图的最高价
      double hight1m = iHigh("GBPUSD",1,3);
      printf(hight1m);
      //从0号序列开始获取前10个K线中最高价的那根K线序号
      //NULL当前K线，第一个0表示当前拖入的时间周期，10表示前10根K线，最后一个0表示从0号开始
      int highbar = iHighest(NULL,0,MODE_HIGH,10,0);
      //从0号序列开始获取前10个K线中最低价的那根K线序号
      int lowbar = iLowest(NULL,0,MODE_LOW,10,0);
      
      //获取10日均线，240代表1小时图的10日均线（可以将mt4语言设置为Englist，导入均线指标在参数中与一下参数对应查看对比）
      double ma0 = iMA(NULL,0,240,0,MODE_SMA,PRICE_CLOSE,0);
      printf("计算移动平均线指标并返回值="+ma0);
      
      //适应iCustom()函数获取自定义指标的数据
   
  }
//+------------------------------------------------------------------+
