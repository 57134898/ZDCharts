using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Expense 的摘要说明
    /// </summary>
    public class Expense : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse Commit()
        {
            string jsonStr = context.Request.Form["formdata"];
            if (jsonStr == null || jsonStr == "")
            {
                return new Tools.JsonResponse() { Code = "9000", Msg = "pendingdata不能为空" };
            }
            var formdata = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.Expense>(jsonStr);
            //TODO 数据处理未完
            return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };

        }
    }
}