using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
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
            jArrr_timeline_Data.Add("2012");
            jArrr_timeline_Data.Add("2013");
            jArrr_timeline_Data.Add("2014");

            JArray jArrrx_xAxis_Data = new JArray();
            //X轴
            jArrrx_xAxis_Data.Add("铸钢公司");
            jArrrx_xAxis_Data.Add("进出口公司");
            jArrrx_xAxis_Data.Add("销售公司");
            jArrrx_xAxis_Data.Add("铸铁公司");


            JArray jArr_options = new JArray();
            //几家公司
            for (int i = 0; i < 4; i++)
            {
                JObject jObjoption_x = new JObject();
                //标题
                jObjoption_x.Add("text", (i + 1).ToString() + "年销售合同情况");
                JArray jArr_series = new JArray();

                //数据 金额 回款 发票 几种类型
                for (int j = 0; j < 3; j++)
                {
                    JObject jOb_series = new JObject();
                    JArray jArr_series_data = new JArray();
                    jArr_series_data.Add(500 * (j * i + 1));
                    jArr_series_data.Add(400);
                    jArr_series_data.Add(300);
                    jArr_series_data.Add(31150);
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


            //{
            //    title: { 'text': '2003全国宏观经济指标' },
            //    series: [
            //        { 'data': dataArr },
            //        { 'data': dataArr },
            //        { 'data': dataArr }
            //    ]
            //},
            context.Response.Write(res.ToString());
        }
    }
}