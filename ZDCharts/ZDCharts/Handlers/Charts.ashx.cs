using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Charts 的摘要说明
    /// </summary>
    public class Charts : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetData1()
        {
            string syear = GetParam("year");
            string smonth = GetParam("month");
            int year = int.Parse(syear);
            List<string> list1 = new List<string>();
            List<decimal?> list2 = new List<decimal?>();
            List<decimal?> list3 = new List<decimal?>();
            List<decimal?> list4 = new List<decimal?>();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                if (smonth == "全部")
                {
                    var list = db.V_Chart1.Where(p => p.myear == year).ToList();
                    foreach (var item in list)
                    {
                        list1.Add(item.bname);
                        list2.Add(item.cash);
                        list3.Add(item.note);
                        list4.Add(item.total);
                    }
                }
                else
                {
                    int month = int.Parse(smonth);
                    var list = db.V_Chart1.Where(p => p.myear == year && p.mmonth == month).ToList();
                    foreach (var item in list)
                    {
                        list1.Add(item.bname);
                        list2.Add(item.cash);
                        list3.Add(item.note);
                        list4.Add(item.total);
                    }
                }

            }
            JObject jo = new JObject();
            jo.Add("list1", JArray.FromObject(list1));
            jo.Add("list2", JArray.FromObject(list2));
            jo.Add("list3", JArray.FromObject(list3));
            jo.Add("list4", JArray.FromObject(list4));
            //Array arr = new Array[] { list1, list2, list3 };
            if (this.UserInfo.RoleID == "01")
            {
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
            }
            else
            {
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = string.Empty };
            }
        }
        public Tools.JsonResponse GetData2()
        {
            string syear = GetParam("year");
            int year = int.Parse(syear);
            string smonth = GetParam("month");
            string company = GetParam("company");
            JArray jArr1 = new JArray();
            JArray jArr2 = new JArray();
            JArray jArr3 = new JArray();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {

                foreach (var item in db.V_Chart2
                    .Where(delegate(DAL.V_Chart2 p)
                        {
                            if (smonth == "全部")
                            {
                                if (company == "全部")
                                {
                                    if (p.myear == year)
                                        return true;
                                }
                                else
                                {
                                    company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                                    if (p.myear == year && p.companyid == company)
                                        return true;
                                }
                            }
                            else
                            {
                                int month = int.Parse(smonth);
                                if (company == "全部")
                                {
                                    if (p.myear == year && p.mmonth == month)
                                        return true;
                                }
                                else
                                {
                                    company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                                    if (p.myear == year && p.companyid == company && p.mmonth == month)
                                        return true;
                                }
                            }
                            return false;
                        }
                        )
                    .GroupBy(p => new { p.rmbtype })
                    .Select(p => new { RmbType = p.Key.rmbtype, Total = p.Sum(q => q.wf3rmb) })
                    .ToList())
                {
                    jArr1.Add(item.RmbType);
                    JObject jo = new JObject();
                    jo.Add("value", item.Total);
                    jo.Add("name", item.RmbType);
                    jArr2.Add(jo);
                }
                foreach (var item in db.V_Chart2.Where(delegate(DAL.V_Chart2 p)
                {
                    if (smonth == "全部")
                    {
                        if (company == "全部")
                        {
                            if (p.myear == year)
                                return true;
                        }
                        else
                        {
                            company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                            if (p.myear == year && p.companyid == company)
                                return true;
                        }
                    }
                    else
                    {
                        int month = int.Parse(smonth);
                        if (company == "全部")
                        {
                            if (p.myear == year && p.mmonth == month)
                                return true;
                        }
                        else
                        {
                            company = COMN.MyFuncs.GetCodeFromStr(company, '-');
                            if (p.myear == year && p.companyid == company && p.mmonth == month)
                                return true;
                        }
                    }
                    return false;
                })
                                      .GroupBy(p => new { p.ncodegroup, p.ncodegroupname })
                                      .Select(p => new { NCodeGroup = p.Key.ncodegroup, NCodeGName = p.Key.ncodegroupname, Total = p.Sum(q => q.wf4rmb) })
                                      .ToList())
                {
                    jArr1.Add(item.NCodeGName);
                    JObject jo = new JObject();
                    jo.Add("value", item.Total);
                    jo.Add("name", item.NCodeGName);
                    jArr3.Add(jo);
                }



                JObject joo = new JObject();
                joo.Add("list1", jArr1);
                joo.Add("list2", jArr2);
                joo.Add("list3", jArr3);
                if (this.UserInfo.RoleID == "01")
                {
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = joo };
                }
                else
                {
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = string.Empty };
                }
            }
        }
        public Tools.JsonResponse GetData3()
        {
            string syear = GetParam("year");
            string smonth = GetParam("month");
            if (smonth == "全部")
            {
                smonth = "12";
            }
            string contracttype = GetParam("contracttype");
            int year = int.Parse(syear);
            int month = int.Parse(smonth);
            contracttype = COMN.MyFuncs.GetCodeFromStr(contracttype, '-');
            string sql = string.Format(@"DECLARE @MYEAR INT DECLARE @MMONTH INT DECLARE @CTYPE VARCHAR(10)
SET @MYEAR ={0}
SET @MMONTH ={1}
SET @CTYPE ='{2}'
SELECT HLX,
       BCode,LName,
       ShortName,
       SUM(TOTAL) TotaL ,
       SUM(RMB) Rmb,
       SUM(INV)Inv
FROM
  (SELECT LName,[HJSJE] TotaL,
          [HLX] ,
          ISNULL(
                   (SELECT SUM(RMB)
                    FROM AFKXX F
                    WHERE F.HTH=H.HCODE
                      AND YEAR([date])<= @MYEAR AND MONTH([date])<= @MMONTH
                      AND [TYPE]= CASE WHEN SUBSTRING(HLX,1,2)='02' THEN '回款' ELSE '付款' END) ,0.00)RMB ,
          ISNULL(
                   (SELECT SUM(RMB)
                    FROM AFKXX F
                    WHERE F.HTH=H.HCODE
                      AND YEAR([date])<= @MYEAR AND MONTH([date])<= @MMONTH
                      AND [TYPE]= CASE WHEN SUBSTRING(HLX,1,2)='02' THEN '销项发票' ELSE '进项发票' END) ,0.00) INV ,
          B.BCode,
          B.ShortName
   FROM [contract1].[dbo].[ACONTRACT] H
   INNER JOIN BCODE B ON H.HDW=B.BCODE INNER JOIN ALX L ON H.HLX=L.LID
   WHERE HLX LIKE @CTYPE+'%' AND  YEAR([Hdate])<= @MYEAR AND MONTH([Hdate])<= @MMONTH) TT
GROUP BY HLX,LName,
         BCode,
         ShortName 
", year, month, contracttype);
            System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
            JArray jArr1 = new JArray();
            //jArr1.Add("结算金额");
            jArr1.Add("货款");
            jArr1.Add("发票");
            JArray jArr2 = new JArray();
            JArray jArr3 = new JArray();
            foreach (System.Data.DataRow r in dt.Rows)
            {
                jArr2.Add(r["ShortName"].ToString().Replace("公司", "") + "-" + r["LName"].ToString());
            }
            foreach (var item in jArr1)
            {
                JObject jo1 = new JObject();
                jo1.Add("name", item.ToString());
                jo1.Add("type", "bar");
                jo1.Add("stack", "总量");
                jo1.Add("itemStyle", "dataStyle");
                JObject jo2 = new JObject();
                jo2.Add("name", item.ToString());
                jo2.Add("type", "bar");
                jo2.Add("stack", "总量");
                jo2.Add("itemStyle", "placeHoledStyle");
                JArray jArrData1 = new JArray();
                JArray jArrData2 = new JArray();
                foreach (System.Data.DataRow r in dt.Rows)
                {
                    if (item.ToString() == "结算金额")
                    {
                        jArrData1.Add(Math.Round(decimal.Parse(r["TotaL"].ToString()) / decimal.Parse(r["TotaL"].ToString()) * 100));
                        jArrData2.Add((decimal.Parse(r["TotaL"].ToString()) - decimal.Parse(r["TotaL"].ToString())) / decimal.Parse(r["TotaL"].ToString()) * 100);
                    }
                    else if (item.ToString() == "货款")
                    {
                        jArrData1.Add(Math.Round(decimal.Parse(r["rmb"].ToString()) / decimal.Parse(r["TotaL"].ToString()) * 100));
                        jArrData2.Add(Math.Round((decimal.Parse(r["TotaL"].ToString()) - decimal.Parse(r["rmb"].ToString())) / decimal.Parse(r["TotaL"].ToString()) * 100));
                    }
                    else
                    {
                        jArrData1.Add(Math.Round(decimal.Parse(r["Inv"].ToString()) / decimal.Parse(r["TotaL"].ToString()) * 100));
                        jArrData2.Add(Math.Round((decimal.Parse(r["TotaL"].ToString()) - decimal.Parse(r["Inv"].ToString())) / decimal.Parse(r["TotaL"].ToString()) * 100));
                    }
                }
                jo1.Add("data", jArrData1);
                jo2.Add("data", jArrData2);
                jArr3.Add(jo1);
                jArr3.Add(jo2);
            }

            JObject data = new JObject();
            data.Add("list1", jArr1);
            data.Add("list2", jArr2);
            data.Add("list3", jArr3);
            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = data };
        }

        public Tools.JsonResponse GetData4()
        {
            string syear = GetParam("year");
            string smonth = GetParam("month");
            if (smonth == "全部")
            {
                smonth = "12";
            }
            int year = int.Parse(syear);
            int month = int.Parse(smonth);
            //TODO 取前8条测试 正式需要去掉
            string sql_company = string.Format(@"SELECT top 8 bcode,REPLACE(REPLACE(bname,'沈阳铸锻工业有限公司',''),'分公司','') bname 
                                                        FROM {0}.dbo.BCODE WHERE LEN(BCODE)=4 AND BCODE BETWEEN 103 AND 130",
                                        COMN.MyVars.CWDB);
            System.Data.DataTable dt_company = DBHelper.ExecuteDataTable(sql_company);
            //TODO 取前5条测试 正式需要去掉
            string sql_ncode = string.Format(@"SELECT  top 5  ncode,nname FROM {0}.dbo.NCODE WHERE NCODE!='' AND LEN(NCODE)=4", COMN.MyVars.CWDB);
            System.Data.DataTable dtn_code = DBHelper.ExecuteDataTable(sql_ncode);
            string sql = string.Format(@"SELECT bcode,REPLACE(REPLACE(bname,'沈阳铸锻工业有限公司',''),'分公司','') bname 
                                                        FROM {0}.dbo.BCODE WHERE LEN(BCODE)=4 AND BCODE BETWEEN 103 AND 130",
                                                    COMN.MyVars.CWDB);
            System.Data.DataTable dt = DBHelper.ExecuteDataTable(sql);
            JArray jArr1 = new JArray();
            jArr1.Add("上月余额");
            jArr1.Add("本月余额");
            JArray jArr2 = new JArray();
            JArray jArr3 = new JArray();


            //上月余额
            JObject jo1 = new JObject();
            jo1.Add("name", "上月余额");
            jo1.Add("type", "bar");
            jo1.Add("stack", "余额");
            JObject jo11 = new JObject();
            jo11.Add("normal", new JObject(new JProperty[] { new JProperty("show", true), new JProperty("position", "inside") }));
            jo1.Add("itemStyle", jo11);
            JArray jArrData1 = new JArray();
            //本月余额
            JObject jo2 = new JObject();
            jo2.Add("name", "本月余额");
            jo2.Add("type", "bar");
            jo2.Add("stack", "余额");
            JObject jo22 = new JObject();
            jo22.Add("normal", new JObject(new JProperty[] { new JProperty("show", true), new JProperty("position", "inside") }));
            jo2.Add("itemStyle", jo22);
            JArray jArrData2 = new JArray();
            foreach (System.Data.DataRow r in dt_company.Rows)
            {
                //公司列表 X轴
                jArr2.Add(r["bname"].ToString());
                // TODO 随机数测试
                Random rd = new Random();
                int a = rd.Next(500);
                jArrData1.Add(a);
            }
            jo1.Add("data", jArrData1);
            jo2.Add("data", jArrData2);
            jArr3.Add(jo1);
            jArr3.Add(jo2);

            foreach (System.Data.DataRow r in dtn_code.Rows)
            {
                //资金类型 图例列表
                jArr1.Add(r["nname"].ToString());
                string stackname = "发生额";
                JObject _jo1 = new JObject();
                _jo1.Add("name", r["nname"].ToString());
                _jo1.Add("type", "bar");
                _jo1.Add("stack", stackname);
                JObject _jo11 = new JObject();
                _jo11.Add("normal", new JObject(new JProperty[] { new JProperty("show", true), new JProperty("position", "inside") }));
                _jo1.Add("itemStyle", _jo11);
                JArray _jArrData1 = new JArray();
                foreach (System.Data.DataRow r1 in dt_company.Rows)
                {
                    if (r["ncode"].ToString().StartsWith("01"))
                    {
                        // TODO 随机数测试
                        Random rd = new Random();
                        int a = rd.Next(500);
                        _jArrData1.Add(a);
                    }
                    else
                    {
                        // TODO 随机数测试
                        Random rd = new Random();
                        int a = rd.Next(500);
                        _jArrData1.Add(-1 * a);
                    }
                }
                _jo1.Add("data", _jArrData1);
                jArr3.Add(_jo1);
            }
            JObject data = new JObject();
            data.Add("list1", jArr1);
            data.Add("list2", jArr2);
            data.Add("list3", jArr3);
            return new Tools.JsonResponse() { Code = "0", Msg = "收支情况图按月拟", Data = data };
        }
    }
}