using Newtonsoft.Json;
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
        public Tools.JsonResponse GetDeptAndRoleList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var depts = db.Org_Depts.ToList();
                var roles = db.Org_Roles.ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = depts, Data0 = roles };
            }
        }
        public Tools.JsonResponse AddUser()
        {
            DAL.Org_Emps user = JsonConvert.DeserializeObject<DAL.Org_Emps>(this.GetParam("userinfo"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var userlist = db.V_Emps.Where(p => p.EmpID == user.EmpID || p.EmpName == user.EmpName);
                if (userlist.Count() > 0)
                {
                    return new Tools.JsonResponse() { Code = "-1", Msg = "用户已经存在" };
                }
                db.Org_Emps.Add(new DAL.Org_Emps()
                {
                    EmpID = user.EmpID,
                    Psw = user.Psw,
                    DeptID = COMN.MyFuncs.GetCodeFromStr(user.DeptID, '-'),
                    RoleID = COMN.MyFuncs.GetCodeFromStr(user.RoleID, '-'),
                    EmpName = user.EmpName,
                    CompanyID = (COMN.MyFuncs.GetCodeFromStr(user.RoleID, '-').Length == 2 ? COMN.MyFuncs.GetCodeFromStr(user.RoleID, '-') : user.DeptID.Substring(0, 4)),
                    IsEnabled = "Y"
                });
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
        public Tools.JsonResponse UpdateUser()
        {
            DAL.Org_Emps user = JsonConvert.DeserializeObject<DAL.Org_Emps>(this.GetParam("userinfo"));

            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var userlist = db.V_Emps.Where(p => p.EmpID != user.EmpID && p.EmpName == user.EmpName);
                if (userlist.Count() > 0)
                {
                    return new Tools.JsonResponse() { Code = "-1", Msg = "用户已经存在" };
                }
                var userinfo = db.Org_Emps.SingleOrDefault(p => p.EmpID == user.EmpID);
                userinfo.EmpName = user.EmpName;
                userinfo.Psw = user.Psw;
                userinfo.DeptID = COMN.MyFuncs.GetCodeFromStr(user.DeptID, '-');
                userinfo.RoleID = COMN.MyFuncs.GetCodeFromStr(user.RoleID, '-');
                userinfo.CompanyID = user.DeptID.Substring(0, 4);
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
        public Tools.JsonResponse StopUser()
        {
            string userid = this.GetParam("userid");
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var user = db.Org_Emps.SingleOrDefault(p => p.EmpID == userid);
                if (user.IsEnabled == "Y")
                {
                    user.IsEnabled = "N";
                }
                else
                {
                    user.IsEnabled = "Y";
                }
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }

        public Tools.JsonResponse GetCompanyList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var list = db.V_BCode.Where(p => p.bcode.StartsWith("01")).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = list };
            }
        }
        public Tools.JsonResponse GetContractTpyeList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                System.Data.DataTable dt = DBHelper.ExecuteDataTable("SELECT [LID],[LNAME] FROM ALX");
                //JArray jArr = JArray.FromObject(dt);
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = dt };
            }
        }

    }
}