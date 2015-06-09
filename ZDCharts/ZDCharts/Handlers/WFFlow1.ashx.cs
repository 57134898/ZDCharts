using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// WFFlow1 的摘要说明
    /// </summary>
    public class WFFlow1 : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetList()
        {
            object oUser = context.Session["user"];
            if (oUser == null)
                return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };

            MODEL.UserInfo user = (MODEL.UserInfo)oUser;
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_Expense
                    .Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == user.RoleID)
                    .GroupBy(p => new { p.CompanyID, p.CompanyName })
                    .Select(p => new { CompanyID = p.Key.CompanyID, CompanyName = p.Key.CompanyName, Rmb = p.Sum(q => q.Rmb) })
                    .ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }

    }
}