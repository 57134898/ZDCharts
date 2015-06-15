using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Report1 的摘要说明
    /// </summary>
    public class Report1 : Tools.ABSHttpHandler
    {
        public override void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //var dt = DBHelper.ExecuteDataTable("select top 10 * from acontract");
            JArray jArrr_timeline_Data = new JArray();
            //时间线
            List<string> yearList = new List<string>() { "2012", "2013", "2014" };
            foreach (var item in yearList)
            {
                jArrr_timeline_Data.Add(item);
            }
            JArray jArrrx_xAxis_Data = new JArray();
            DataTable dt_companys = DBHelper.ExecuteDataTable("SELECT TOP 8 CCODE,CNAME FROM ACLIENTS WHERE LEN(CCODE)=4 AND CCODE LIKE '01%' AND CCODE NOT IN('0104',0108,'0101')");
            DataTable dt_jsje = DBHelper.ExecuteDataTable("SELECT HDW,YEAR(签订日期) AS YEAR,Convert(decimal(18,2),SUM(结算金额)/10000) AS RMB FROM vcontracts  WHERE HLX like '02%'  GROUP BY HDW,YEAR(签订日期) ORDER BY 3 DESC");
            DataTable dt_rmb = DBHelper.ExecuteDataTable("SELECT HDW,YEAR(签订日期) AS YEAR,Convert(decimal(18,2),SUM(金额)/10000) AS RMB FROM vcontracts   WHERE HLX like '02%'  GROUP BY HDW,YEAR(签订日期) ORDER BY 1");
            DataTable dt_voice = DBHelper.ExecuteDataTable("SELECT HDW,YEAR(签订日期) AS YEAR,Convert(decimal(18,2),SUM(发票)/10000) AS RMB FROM vcontracts  WHERE HLX like '02%'  GROUP BY HDW,YEAR(签订日期) ORDER BY 1");

            
            //X轴
            foreach (DataRow r in dt_companys.Rows)
            {
                jArrrx_xAxis_Data.Add(r["cname"].ToString().Substring(10).Replace("公司", ""));
            }



            JArray jArr_options = new JArray();
            //时间轴几年
            foreach (var year in yearList)
            {
                JObject jObjoption_x = new JObject();
                //标题
                jObjoption_x.Add("text", year + "年销售合同情况");
                JArray jArr_series = new JArray();
                //数据 金额 回款 发票 几种类型
                for (int j = 0; j < 3; j++)
                {
                    JObject jOb_series = new JObject();
                    JArray jArr_series_data = new JArray();
                    //几家公司
                    foreach (DataRow item in dt_companys.Rows)
                    {
                        if (j == 0)
                        {
                            var v = dt_jsje.AsEnumerable().FirstOrDefault(p => p["HDW"].ToString() == item["CCODE"].ToString() && p["YEAR"].ToString() == year);
                            if (v != null)
                            {
                                jArr_series_data.Add(v["rmb"].ToString());
                            }
                            else
                            {
                                jArr_series_data.Add(0);
                            }
                        }
                        if (j == 1)
                        {
                            var v = dt_rmb.AsEnumerable().FirstOrDefault(p => p["HDW"].ToString() == item["CCODE"].ToString() && p["YEAR"].ToString() == year);
                            if (v != null)
                            {
                                jArr_series_data.Add(v["rmb"].ToString());
                            }
                            else
                            {
                                jArr_series_data.Add(0);
                            }
                        }
                        if (j == 2)
                        {
                            var v = dt_voice.AsEnumerable().FirstOrDefault(p => p["HDW"].ToString() == item["CCODE"].ToString() && p["YEAR"].ToString() == year);
                            if (v != null)
                            {
                                jArr_series_data.Add(v["rmb"].ToString());
                            }
                            else
                            {
                                jArr_series_data.Add(0);
                            }
                        }

                    }

                    jOb_series.Add("data", jArr_series_data);
                    jArr_series.Add(jOb_series);
                }

                jObjoption_x.Add("series", jArr_series);
                jArr_options.Add(jObjoption_x);
            }
            JObject res = new JObject();
            res.Add("jArrr_timeline_Data", jArrr_timeline_Data);
            res.Add("jArrrx_xAxis_Data", jArrrx_xAxis_Data);
            res.Add("jArr_options", jArr_options);
            context.Response.Write(res.ToString());
        }
    }
}