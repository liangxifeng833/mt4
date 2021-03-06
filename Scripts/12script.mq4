#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| 高级对象的画法及获取其值                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      /**
      * 斐波那契回调线，需要两个坐标，分别是最高点和最低点
      * 手动指定挡位划线
      **/
      /*
      //第一个参数与11script中第一个参数不一样，第一个参数为货币对图表的编号
      ObjectCreate(0,"8",OBJ_FIBO,0,Time[24],High[24],Time[53],Low[53]);
      //指定斐波那契回调线的挡位（总计几条线），这里是5条
      ObjectSetInteger(0,"8",OBJPROP_LEVELS,5);    
      //第一条线(最下面的一条)
      ObjectSetDouble(0,"8",OBJPROP_LEVELVALUE,0,0);   //水平位值
      ObjectSetString(0,"8",OBJPROP_LEVELTEXT,0,"0");        
      //第二条线
      ObjectSetDouble(0,"8",OBJPROP_LEVELVALUE,1,0.23);   //水平位值
      ObjectSetString(0,"8",OBJPROP_LEVELTEXT,1,"23");      //说明
      //第三条线
      ObjectSetDouble(0,"8",OBJPROP_LEVELVALUE,2,0.5);
      ObjectSetString(0,"8",OBJPROP_LEVELTEXT,2,"50");
      //第四条线
      ObjectSetDouble(0,"8",OBJPROP_LEVELVALUE,3,0.618);
      ObjectSetString(0,"8",OBJPROP_LEVELTEXT,3,"61.8");
      //第五条线
      ObjectSetDouble(0,"8",OBJPROP_LEVELVALUE,4,1);
      ObjectSetString(0,"8",OBJPROP_LEVELTEXT,4,"100");   
      */   
      
      /**
      * 划等距通道线, 由三个坐标确定
      **/
      //ObjectCreate(0,"8",OBJ_CHANNEL,0,Time[24],High[24],Time[53],Low[53],Time[1],Open[1]);
      /**
      * 线性回归通道线, 由两个时间点确定，系统自动划出
      * 所以两个坐标Y轴对应的值=0即可
      **/      
      //ObjectCreate(0,"10",OBJ_REGRESSION,0,Time[20],0,Time[0],0);
      //ObjectSetInteger(0,"10",OBJPROP_RAY_RIGHT,True); //右射线设置为True
      
      /**
      * 标准差通道线, 由两个时间点确定，系统自动划出
      * 所以两个坐标Y轴对应的值=0即可
      **/      
      //ObjectCreate(0,"11",OBJ_STDDEVCHANNEL,0,Time[20],0,Time[0],0);  
      //ObjectSetDouble(0,"11",OBJPROP_DEVIATION,1.8); //设置偏差（通道线之间的距离）
      
      /**
      * 斐波那契通道线, 由三个坐标确定
      **/
      //ObjectCreate(0,"12",OBJ_FIBOCHANNEL,0,Time[24],High[24],Time[53],Low[53],Time[1],Open[1]);   
      
      /**
      * 江恩扇形线, 由两个坐标确定
      **/
      //ObjectCreate(0,"13",OBJ_GANNFAN,0,Time[20],Low[20],Time[0],0);     
      //ObjectSetDouble(0,"13",OBJPROP_SCALE,19.8); //设置比例  
      
      /**
      * 斐波那契扇形线，需要两个坐标，分别是最高点和最低点
      * 手动指定挡位划线
      **/
      /*
      //第一个参数与11script中第一个参数不一样，第一个参数为货币对图表的编号
      ObjectCreate(0,"14",OBJ_FIBOFAN,0,Time[24],High[24],Time[53],Low[53]);
      //指定斐波那契回调线的挡位（总计几条线），这里是5条
      ObjectSetInteger(0,"",OBJPROP_LEVELS,5);    
      //第一条线(最下面的一条)
      ObjectSetDouble(0,"14",OBJPROP_LEVELVALUE,0,0);   //水平位值
      ObjectSetString(0,"14",OBJPROP_LEVELTEXT,0,"0");        
      //第二条线
      ObjectSetDouble(0,"14",OBJPROP_LEVELVALUE,1,0.23);   //水平位值
      ObjectSetString(0,"14",OBJPROP_LEVELTEXT,1,"23");      //说明
      //第三条线
      ObjectSetDouble(0,"14",OBJPROP_LEVELVALUE,2,0.5);
      ObjectSetString(0,"14",OBJPROP_LEVELTEXT,2,"50");
      //第四条线
      ObjectSetDouble(0,"14",OBJPROP_LEVELVALUE,3,0.618);
      ObjectSetString(0,"14",OBJPROP_LEVELTEXT,3,"61.8");
      //第五条线
      ObjectSetDouble(0,"14",OBJPROP_LEVELVALUE,4,1);
      ObjectSetString(0,"14",OBJPROP_LEVELTEXT,4,"100");  
      */
      
      
      //划斐波那契扩展图
      //ObjectCreate(0,"15",OBJ_EXPANSION,0,Time[53],High[53],Time[19],High[19],Time[1],Low[1]); 
      
      //划安德鲁分叉线
      //ObjectCreate(0,"16",OBJ_PITCHFORK,0,Time[53],High[53],Time[19],High[19],Time[1],Low[1]);
      
      // 斐波纳契时间周期线
      //ObjectCreate(0,"17",OBJ_FIBOTIMES,0,Time[53],High[53],Time[19],High[19]);
      
      // 划圆形
      //ObjectCreate(0,"18",OBJ_ELLIPSE,0,Time[53],High[53],Time[19],High[19]);
      //ObjectSetDouble(0,"18",OBJPROP_SCALE,0.01); //圆的宽度scale, 1=一条直线
      
      //划方形, 需要对角两个点坐标
      //ObjectCreate(0,"19",OBJ_RECTANGLE,0,Time[53],High[53],Time[19],High[19]);
      
      //划三角形, 需要对角三个点坐标
      //ObjectCreate(0,"20",OBJ_TRIANGLE,0,Time[53],High[53],Time[19],High[19],Time[1],Low[1]);   
      
      if (GlobalVariableCheck("s") == false)
      {
         GlobalVariableSet("s",1);
      }
      //通过名字找到该圆形，然后进行修改圆形的饱满度
      if(ObjectFind("21") >= 0) 
      {
         Alert("zhaodao");
         ObjectSetDouble(0,"21",OBJPROP_SCALE,GlobalVariableGet("s")-0.1);
         GlobalVariableSet("s",GlobalVariableGet("s")-0.1);
      }else
      {
         Alert("no zhaodao");
         ObjectCreate(0,"21",OBJ_ELLIPSE,0,Time[53],High[53],Time[19],High[19]);
         ObjectSetInteger(0,"21",OBJPROP_COLOR,Yellow);
      }
      
      //删除指定对象
      ObjectDelete("21")
      //删除所有垂直直线
      ObjectsDeleteAll(0,OBJ_VLINE,)
        
          
  }
