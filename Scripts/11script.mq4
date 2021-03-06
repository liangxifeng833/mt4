#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| 对象的基本操作:在图标上写字,画趋势线等                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
   /**
   * 创建水平线，垂直线等对象
   * 第一参数：对象名称
   * 第二个参数：对象类型，水平/垂直等等
   * 第三个参数：窗口号，0代表主窗口,1代表辅窗口，比如：MACD图形窗口
   * 第四个参数：X轴坐标，时间 Time[1] 一号K线时间 (第一个坐标)
   * 第五个参数：Y轴坐标，价格 Open[1] 1号K线开盘价(第一个坐标)
   **/
   //垂直线
   //ObjectCreate("1",OBJ_VLINE,0,Time[1],Open[1]); 
   //水平线
   /*
   ObjectCreate("2",OBJ_HLINE,0,Time[1],Open[1]);
   //获取水平线对应的价格 OBJPROP_PRICE1 注意；PRICE后面有一个1,代表1号K线
   double shuipingPrice = ObjectGet("2",OBJPROP_PRICE1);
   Alert("水平线的价格="+shuipingPrice);
   */

   //角度线,需要两个坐标
   /*
   ObjectCreate("4",OBJ_TRENDBYANGLE,0,Time[10],Open[10],Time[0],Low[0]); 
   ObjectSet("4",OBJPROP_ANGLE,45); //角度45度
   ObjectSet("4",OBJPROP_COLOR,clrWhite); //颜色白色 
   //获取角度值
   int jiaodu =  ObjectGet("4",OBJPROP_ANGLE);
   */

   
   //斐波那契回调线,需要两个坐标
   /*
   ObjectCreate("5",OBJ_FIBO,0,Time[10],Low  [10],Time[0],High[0]); 
   ObjectSet("4",OBJPROP_ANGLE,45); //角度45度
   ObjectSet("4",OBJPROP_COLOR,clrWhite); //颜色白色 
   */
   
   
   /**
   * 修改已经画好对象的属性，比如：颜色，粗细等等
   **/
   //修改刚刚画好的水平线的颜色
   /*
   ObjectSet("2",OBJPROP_COLOR,Yellow); //修改为黄色
   ObjectSet("2",OBJPROP_WIDTH,3);      //修改水平线宽度
   */

   
   //趋势线（斜线），需要两个坐标
   /*
   ObjectCreate("3",OBJ_TREND,0,Time[10],Open[10],Time[0],Low[0]); 
   //设置趋势线为非射线,划线段，否则会无线延长为射线
   ObjectSet("3",OBJPROP_RAY,False  );
   //根据序号获取趋势线对应的,0号K线对应趋势线的价格    
   double jiage0 = ObjectGetValueByShift("3",1);
   Alert("0号K线对应趋势线的价格="+jiage0);
   */
   
   /**
   * 写文字Text方式
   * 是相对定位，位置随着时间的移动而移动
   **/  
   //先创建OBJ_TEXT类型的文字对象
   ObjectCreate("6",OBJ_TEXT,0,Time[11],Open[11]);
   //在该对象上写字，12号大小，宋体，黄色
   ObjectSetText("6","你好我是Text类型文字",12,"宋体",Yellow);
   
   /**
   * 写文字Label方式
   * 绝对定位，固定在窗口某一个位置
   * 坐标原点(0,0)默认位置：窗口左上角
   * 坐标单位是像素
   **/ 
   //LABEL对象创建 X坐标=10像素，Y坐标=10像素
   ObjectCreate("7",OBJ_LABEL,0,10,10); 
   //坐标原点可以自定义为左下，右上，或者右下，默认：左上
   //将原点修改为左下
   ObjectSet("7",OBJPROP_CORNER,CORNER_LEFT_LOWER);
   //设置文字X轴像素值=150
   ObjectSet("7",OBJPROP_XDISTANCE,150);
   //设置文字Y轴像素值=15
   ObjectSet("7",OBJPROP_YDISTANCE,15);
   //在该对象上写字，12号大小，宋体，黄色
   ObjectSetText("7","你好我是Label类型文字",16,"宋体",Yellow);
   
   //获取对象的总数（包含订单信息）
   int objTotal = ObjectsTotal();
   for(int i=objTotal; i>=0; i--)
   {
      //通过对象名字，就可以操作该对象了
      printf("对象名字="+ObjectName(i));
      //删除对象
      //ObjectDelete(ObjectName(i));
   }
   
   
   
   
   
   
  }
