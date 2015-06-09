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
        protected MODEL.UserInfo UserInfo { get; private set; }
        public virtual void ProcessRequest(HttpContext context)
        {
            this.context = context;
            string action = context.Request.Params["Action"];
            Tools.JsonResponse tr = null;
            if (action == null || action == "")
            {
                tr = new Tools.JsonResponse() { Code = "1001", Msg = "action为空" };
            }
            var method = this.GetType().GetMethod(action);
            if (method == null)
            {
                tr = new Tools.JsonResponse() { Code = "1002", Msg = "未找到action对应的方法" };
            }
            object oUser = context.Session["user"];
            if (oUser == null)
            {
                tr = new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
            }
            if (tr != null)
            {
                this.DoResponse(tr, context);
                return;
            }
            this.UserInfo = (MODEL.UserInfo)oUser;
            tr = (Tools.JsonResponse)this.GetType().GetMethod(action).Invoke(this, null);
            this.DoResponse(tr, context);
        }

        protected string GetParam(string pName)
        {
            string p = this.context.Request.Params[pName];
            if (string.IsNullOrEmpty(p))
            {
                throw new Exception(string.Format("[{0}]参数不能为空", pName));
            }
            return p;
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