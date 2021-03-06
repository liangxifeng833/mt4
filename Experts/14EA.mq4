#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
extern double 下单量=0.1;
extern int 止损点数=200;
extern int 止盈点数=200;
/**
* 使用文件保存EA参数
* 第一次加载该EA的时候程序会自动在files目录下14EA.csv文件,存放下单量,止损点数, 止盈点数
* 下一次加载该EA的时候判断参数下单量,止损点数,止盈点数是否有变化,
* 如果没有变化则读取文件中的对应值
* 如果有变化则使用变化的新值,同时将新值存入csv文件.  
* 最后根据参数buy订单 
*/
int OnInit()
  {
    string eaname=WindowExpertName();//当前EA名字
    string filename=eaname+".csv";
    int h;
    //如果文件不存在,则新建
    if(FileIsExist(filename)==false)
      {
        h=FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_READ,",",CP_ACP);
        if(h!=INVALID_HANDLE)
          {
            FileWrite(h,下单量,止损点数,止盈点数);
            FileClose(h);
          }
      }
    else
      {
        //文件存在，判断该EA的时候判断参数下单量,止损点数,止盈点数是否有变化，
        // 如果没有变化则读取文件中的对应值
        if(NormalizeDouble(下单量,2)==0.1 && 止损点数==200 && 止盈点数==200)
          {
            h=FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_READ,",",CP_ACP);
            if(h!=INVALID_HANDLE)
             {
               int jishu=0;
               while(FileIsEnding(h)!=True)
                {
                  string read=FileReadString(h);
                  if(jishu==0)下单量=StringToDouble(read);
                  if(jishu==1)止损点数=StringToInteger(read);
                  if(jishu==2)止盈点数=StringToInteger(read);
                  jishu++;
                }
               FileClose(h);
             }
          }
        //如果有变化则使用变化的新值,同时将新值存入csv文件.
        h=FileOpen(filename,FILE_READ|FILE_WRITE|FILE_CSV|FILE_SHARE_READ,",",CP_ACP);
        if(h!=INVALID_HANDLE)
          {
            FileWrite(h,下单量,止损点数,止盈点数);
            FileClose(h);
          }
      }
    //将下单量，止损点数，止盈点数作为Label写在货币图的左上角
    wenzi("lots","下单量="+DoubleToStr(下单量,2),15,15,10,Red);
    wenzi("zhisun","止损点数="+止损点数,15,30,10,Red);
    wenzi("zhiying","止盈点数="+止盈点数,15,45,10,Red);
   return(INIT_SUCCEEDED);
  }
void OnDeinit(const int reason)
  {

  }
void OnTick()
  {
     buy(下单量,止损点数,止盈点数,Symbol()+"buy",45632);
  }
void wenzi(string name,string neirong,int x,int y,int daxiao,color yanse)
  {
    if(ObjectFind(name)<0)
     {
        ObjectCreate(name,OBJ_LABEL,0,0,0);
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        ObjectSet(name,OBJPROP_XDISTANCE,x);
        ObjectSet(name,OBJPROP_YDISTANCE,y);
        ObjectSet(name,OBJPROP_CORNER,0);
     }
    else
     {
        ObjectSetText(name,neirong,daxiao,"宋体",yanse);
        WindowRedraw();
     }
  }
int buy(double lots,double sl,double tp,string com,int buymagic)
  {
    int a=0;
    bool zhaodan=false;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            string zhushi=OrderComment();
            int ma=OrderMagicNumber();
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
              {
                zhaodan=true;
                break;
              }
          }
      }
    if(zhaodan==false)
      {
        if(sl!=0 && tp==0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,White);
         }
        if(sl==0 && tp!=0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,Ask+tp*Point,com,buymagic,0,White);
         }
        if(sl==0 && tp==0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,com,buymagic,0,White);
         }
        if(sl!=0 && tp!=0)
         {
          a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,White);
         } 
      }
    return(a);
  }