using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Reoprts 的摘要说明
    /// </summary>
    public class Reoprts : Tools.ABSHttpHandler
    {

        public Tools.JsonResponse GetData1()
        {

            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = string.Empty };
        }
    }
}