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
        public Tools.JsonResponse GetListGroupByCompany()
        {
            object oUser = context.Session["user"];
            if (oUser == null)
                return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };

            MODEL.UserInfo user = (MODEL.UserInfo)oUser;
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                //权限控制 0199 为资金池李慧 01 和02 为副总
                var fList = db.V_Expense
                    .Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == user.RoleID)
                    .GroupBy(p => new
                    {
                        p.CompanyID,
                        p.CompanyName
                    })
                    .Select(p => new
                    {
                        CompanyID = p.Key.CompanyID,
                        CompanyName = p.Key.CompanyName,
                        Total = p.Sum(q => q.Rmb)
                    })
                    .ToList();
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = "操作成功",
                    Data = fList
                };
            }
        }

        public Tools.JsonResponse GetListGroupByDoc()
        {
            string companyid = this.GetParam("companyid");
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                //权限控制 0199 为资金池李慧 01 和02 为副总
                var fList = db.V_Expense
                    .Where(p =>
                        (p.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsHandling
                        || p.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsStarted)
                        && p.RoleID == this.UserInfo.RoleID)
                    .ToList();
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = "操作成功",
                    Data = fList
                };
            }
        }

        public Tools.JsonResponse GetList()
        {
            int myid = int.Parse(this.GetParam("myid"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_ExpenseRows
                    .Where(p => p.WF4RowResult != COMN.MyVars.No && p.ID == myid)
                    .ToList();
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = "操作成功",
                    Data = fList
                };
            }
        }

        public Tools.JsonResponse GetStepList()
        {
            int flowID = int.Parse(this.GetParam("flowid"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                var list = db.V_ApprovalSteps
                    .Where(p => p.ID == flowID)//.OrderBy(p => p.TemRowID)
                    .ToList();
                var curNode = db.WF_Flows.SingleOrDefault(p => p.ID == flowID);
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = curNode.CurNode.ToString(),
                    Data = list
                };
            }
        }

        public Tools.JsonResponse Commit()
        {
            string jsonStr = this.GetParam("pendingdata");
            Newtonsoft.Json.Linq.JArray jArr = Newtonsoft.Json.Linq.JArray.Parse(jsonStr);
            if (jArr.Count <= 0)
                return new Tools.JsonResponse() { Code = "9001", Msg = "没有审批数据" };
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                int rowid = int.Parse(jArr[0]["fid"].ToString().Substring(1));
                var wf4 = db.WF_Flow4.SingleOrDefault(p => p.ID == rowid);
                var flow = db.WF_Flows.SingleOrDefault(p => p.FID == wf4.FlowID);
                var wf3 = db.WF_Flow3.SingleOrDefault(p => p.FlowID == wf4.FlowID);
                var temrow = db.WF_TemRows.SingleOrDefault(p => p.TemID == flow.TemID && p.RID == flow.CurNode);
                var rList = jArr.Where(p => p["result"].ToString() == "Y");
                if (rList.Count() > 0)
                {
                    //
                    //如果没有下一节,审批结束
                    if (temrow.NextID == 0)
                    {
                        flow.IsFinished = "Y";
                        flow.Result = "Y";
                        flow.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsAccpeted;
                    }
                    else
                    {
                        flow.IsFinished = "N";
                        flow.Result = "Y";
                        flow.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsHandling;
                        flow.Result = COMN.MyVars.Pending;
                    }
                    db.WF_Nodes.Add(new DAL.WF_Nodes()
                    {
                        TemRowID = flow.CurNode,
                        FlowID = flow.FID,
                        Result = "Y",
                        CreatedDate = DateTime.Now
                    });
                    //TODO没有全部拒绝审批继续 
                }
                else
                {
                    //所有行都未通过点则审批结束
                    flow.IsFinished = "Y";
                    flow.Result = "N";
                    flow.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsRefused;
                    db.WF_Nodes.Add(new DAL.WF_Nodes()
                    {
                        TemRowID = flow.CurNode,
                        FlowID = flow.FID,
                        Result = "N",
                        CreatedDate = DateTime.Now
                    });
                }
                flow.CurNode = temrow.NextID;
                foreach (var item in jArr)
                {
                    int _rowid = int.Parse(item["fid"].ToString().Substring(1));
                    var wf4r = db.WF_Flow4.SingleOrDefault(p => p.ID == _rowid);
                    wf4r.Result = item["result"].ToString();
                }
                wf3.Rmb = db.WF_Flow4.Where(p => p.FlowID == wf4.FlowID && p.Result != "N").Sum(p => p.Rmb);
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}