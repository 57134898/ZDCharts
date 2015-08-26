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
                var mp = db.Sys_MenuPermission.SingleOrDefault(p => p.RoleID == this.UserInfo.RoleID);
                List<string> menuids = mp.MenuID.Split(',').ToList();
                var menulist = db.Sys_Menus.Where(delegate(DAL.Sys_Menus p)
                {
                    if (p.IsEnabled == "Y" && menuids.FindIndex(q => q == p.MenuID) > -1)
                    {
                        return true;
                    }
                    return false;
                }).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = menulist };
            }
        }
    }
}