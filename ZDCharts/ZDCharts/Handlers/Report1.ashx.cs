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
            JArray jArr = new JArray(new string[] { "老刘", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子" });
            JObject opt = new JObject();


            opt.Add("tooltip", new JObject(new JObject("timeline", new JProperty("data", new JArray() { "2012", "2014", "2013" }), new JProperty("autoPlay", true), new JProperty("playInterval", 1000))));
            opt.Add("legend", new JObject(new JProperty("data", new JArray("销量lol"))));
            opt.Add("xAxis", new JArray(new JObject(new JProperty("type", "category"), new JProperty("data", jArr))));
            opt.Add("yAxis", new JArray(new JObject(new JProperty("type", "value"))));
            opt.Add("series", new JArray(new JObject(new JProperty("name", "销量"), new JProperty("type", "bar"), new JProperty("data", new JArray(5, 20, 40, 10, 10, 20)))));
            context.Response.Write(opt.ToString());
        }
    }
}