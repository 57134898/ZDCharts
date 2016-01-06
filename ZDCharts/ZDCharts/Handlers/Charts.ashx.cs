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
        public Tools.JsonResponse Getlist()
        {


            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = "aaa" };

        }
    }
}