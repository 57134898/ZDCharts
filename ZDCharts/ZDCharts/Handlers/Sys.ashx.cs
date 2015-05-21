using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Sys 的摘要说明
    /// </summary>
    public class Sys : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetMenuList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //string pStr = context.Request.Form["p"];
                var menulist = db.Sys_Menus.ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = menulist };
            }
        }
    }
}