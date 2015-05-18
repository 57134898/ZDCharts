using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace ZDCharts.Tools
{
    public class ABSHttpHandler : IHttpHandler, IRequiresSessionState
    {
        protected HttpContext context;
        public virtual void ProcessRequest(HttpContext context)
        {
            this.context = context;
            string action = context.Request.Form["Action"];
            Tools.JsonResponse tr;
            if (action == null || action == "")
            {
                tr = new Tools.JsonResponse() { Code = "1001", Msg = "action为空" };
            }
            var method = this.GetType().GetMethod(action);
            if (method == null)
            {
                tr = new Tools.JsonResponse() { Code = "1002", Msg = "未找到action对应的方法" };
            }
            tr = (Tools.JsonResponse)this.GetType().GetMethod(action).Invoke(this, null);
            this.DoResponse(tr, context);
        }

        public void DoResponse(Tools.JsonResponse jresp, HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            Newtonsoft.Json.Linq.JObject jo = new Newtonsoft.Json.Linq.JObject();
            jo.Add("code", jresp.Code);
            jo.Add("msg", jresp.Msg);
            if (jresp.Data != null)
            {
                jo.Add("data", Newtonsoft.Json.Linq.JToken.FromObject(jresp.Data));
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