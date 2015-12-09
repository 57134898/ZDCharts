using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// LogIn 的摘要说明
    /// </summary>
    public class LogIn : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse ValidateUser()
        {
            string username = context.Request.Form["u"];
            string password = context.Request.Form["p"];
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var user = db.Org_Emps.SingleOrDefault(p => p.EmpName == username && password == p.Psw && p.IsEnabled == "Y");
                if (user == null)
                {
                    return new Tools.JsonResponse() { Code = "9009", Msg = "用户名或者密码错误", Data = "" };
                }
                else
                {
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = user };
                }
            }
        }
    }
}