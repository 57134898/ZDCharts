using Newtonsoft.Json.Linq;
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
        public Tools.JsonResponse GetUserList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string pStr = context.Request.Form["p"];
                JArray pJArr = JArray.Parse(pStr);
                var pageStartJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "start");
                var pageLengthJo = pJArr.SingleOrDefault(p => p["name"].ToString() == "length");
                int pStart = int.Parse(pageStartJo["value"].ToString());
                int pLength = int.Parse(pageLengthJo["value"].ToString());
                var searchObj = pJArr.SingleOrDefault(p => p["name"].ToString() == "search");
                var searchTxt = searchObj["value"]["value"].ToString();
                JObject jo = new JObject();
                int pageTotal = 0;
                MODEL.UserInfo user = this.UserInfo;
                //业务逻辑代码↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
                IQueryable<DAL.V_Emps> tempList;
                if (string.IsNullOrEmpty(searchTxt))
                {
                    tempList = db.V_Emps;
                }
                else
                {
                    tempList = db.V_Emps.Where(p => p.EmpID.IndexOf(searchTxt) >= 0
                                                                        || p.EmpName.IndexOf(searchTxt) >= 0
                                                                        || p.DeptID.IndexOf(searchTxt) >= 0
                                                                        || p.DeptName.IndexOf(searchTxt) >= 0
                                                                        || p.RoleID.IndexOf(searchTxt) >= 0
                                                                        || p.RoleName.IndexOf(searchTxt) >= 0
                                                                        || p.IsEnabled.IndexOf(searchTxt) >= 0
                                                                        );
                }
                if (tempList.Count() > 0)
                {
                    var pageList = tempList.OrderBy(p => p.EmpID).Skip(pStart).Take(pLength).ToList();
                    jo.Add("data", JToken.FromObject(pageList));
                }
                else
                {
                    jo.Add("data", string.Empty);
                }
                //业务逻辑代码 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
                pageTotal = tempList.Count();
                jo.Add("recordsTotal", pageTotal);
                jo.Add("recordsFiltered", pageTotal);
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = jo };
            }
        }

    }
}