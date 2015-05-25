using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// WFFlow 的摘要说明
    /// </summary>
    public class WFFlow : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string selectCustomerID = context.Request.Form["SelectCustomerID"];
                object oUser = context.Session["user"];
                if (oUser == null)
                {
                    return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
                }
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_Flows.Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == user.RoleID && p.CustomerID == selectCustomerID).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }

        public Tools.JsonResponse GetListGbCompany()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                object oUser = context.Session["user"];
                if (oUser == null)
                {
                    return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
                }
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                //根据公司角色查找用户可以审批的节点 01与02与集团 可以看所有
                if (user.RoleID == "01" || user.RoleID == "02")
                {
                    var fList = db.V_Flow_GB_Company.Where(p => p.RoleID == user.RoleID).ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
                }
                else
                {
                    var fList = db.V_Flow_GB_Company.Where(p => p.RoleID == user.RoleID && p.CompanyID == user.CompanyID).ToList();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
                }
            }
        }

        public Tools.JsonResponse GetListGbCustomer()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                string selectCompanyID = context.Request.Form["SelectCompanyID"];

                object oUser = context.Session["user"];
                if (oUser == null)
                {
                    return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
                }
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_Flow_GB_Customer.Where(p => p.RoleID == user.RoleID && p.CompanyID == selectCompanyID).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }

        public Tools.JsonResponse Commit()
        {
            string jsonStr = context.Request.Form["pendingdata"];
            if (jsonStr == null || jsonStr == "")
            {
                return new Tools.JsonResponse() { Code = "9000", Msg = "pendingdata不能为空" };
            }
            Newtonsoft.Json.Linq.JArray jArr = Newtonsoft.Json.Linq.JArray.Parse(jsonStr);
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                foreach (var item in jArr)
                {
                    Guid curguid = Guid.Parse(item["fid"].ToString());
                    //查找待审批工作流节点
                    var flow = db.V_Flows.SingleOrDefault(p => p.FID == curguid);
                    if (flow == null)
                        return new Tools.JsonResponse() { Code = "9001", Msg = "未找到节点" };
                    //查找待审批阶段
                    var temrow = db.WF_TemRows.SingleOrDefault(p => p.TemID == flow.TemID && p.RID == flow.RID);
                    if (temrow == null)
                        return new Tools.JsonResponse() { Code = "9001", Msg = "未找审批阶段" };
                    //查找待审批数据
                    var f = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                    if (f == null)
                        return new Tools.JsonResponse() { Code = "9001", Msg = "未找到待审批数据" };
                    //如果没有下一节点则审批借宿
                    if (temrow.NextID < 0)
                    {
                        f.IsFinished = "Y";
                        //审批完成，生成记录到合同软件
                        db.ACash.Add(new DAL.ACash()
                        {
                            //应该写到循环外 --待改
                        });


                        //审批完成，生成记录到资金池

                        //,,,,未完
                    }

                    f.CurNode = temrow.NextID;
                    db.WF_Nodes.Add(new DAL.WF_Nodes()
                    {
                        TemRowID = flow.RID,
                        FlowID = flow.FID,
                        Result = item["result"].ToString().ToUpper(),
                        CreatedDate = DateTime.Now
                    });
                }
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}