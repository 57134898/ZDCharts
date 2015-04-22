using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace ZDCharts
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            //DBHelper.DBHelperInit(1);
            DBHelper.DBHelperInit(2);
        }

        /// <summary>
        /// 全局错误拦截
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = this.Server.GetLastError().GetBaseException();
            if (!(ex is HttpException))
            {
                Response.ContentType = "text/plain";
                Newtonsoft.Json.Linq.JObject jo = new Newtonsoft.Json.Linq.JObject();
                jo.Add("code", "10000");
                jo.Add("msg", ex.Message);
                jo.Add("data", ex.ToString());
                Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(jo));
                Server.ClearError();
            }
        }


    }
}