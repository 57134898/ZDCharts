using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Tools
{
    public class ABSHttpHandler : IHttpHandler
    {
        public virtual void ProcessRequest(HttpContext context)
        {
            string action = context.Request.Form["Action"];
            if (action == null || action == "")
            {
                DoResponse("1001", "action为空", null, context);
                return;
            }
            var method = this.GetType().GetMethod(action);
            if (method == null)
            {
                DoResponse("1002", "未找到action对应的方法", null, context);
                return;
            }
            object data = this.GetType().GetMethod(action).Invoke(this, null);
            DoResponse("0", "操作成功", data, context);
        }

        public void DoResponse(string code, string msg, object data, HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            Newtonsoft.Json.Linq.JObject jo = new Newtonsoft.Json.Linq.JObject();
            jo.Add("code", code);
            jo.Add("msg", msg);
            if (data != null)
            {
                jo.Add("data", Newtonsoft.Json.Linq.JToken.FromObject(data));
            }
            context.Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}