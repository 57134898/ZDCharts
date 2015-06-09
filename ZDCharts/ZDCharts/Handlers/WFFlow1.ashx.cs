﻿using System;
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
        public Tools.JsonResponse GetList()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_Expense
                    .Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == this.UserInfo.RoleID)
                    .ToList();
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = "操作成功",
                    Data = fList
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
                foreach (var item in jArr)
                {
                    string result = item["result"].ToString();
                    Guid flowID = Guid.Parse(item["fid"].ToString());
                    var flow = db.WF_Flows.SingleOrDefault(p => p.FID == flowID);
                    if (flow == null)
                        return new Tools.JsonResponse() { Code = "9001", Msg = "未找到节点" };
                    var temrow = db.WF_TemRows.SingleOrDefault(p => p.TemID == flow.TemID && p.RID == flow.CurNode);
                    if (temrow == null)
                        return new Tools.JsonResponse() { Code = "9002", Msg = "未找审批阶段" };
                    if (temrow.NextID == 0 || result == COMN.MyVars.No)
                    {
                        flow.IsFinished = "Y";
                        flow.Result = result;
                    }
                    else
                    {
                        flow.IsFinished = "N";
                        flow.Result = COMN.MyVars.Pending;
                    }
                    flow.CurNode = temrow.NextID;
                    db.WF_Nodes.Add(new DAL.WF_Nodes()
                    {
                        TemRowID = flow.CurNode,
                        FlowID = flow.FID,
                        Result = result,
                        CreatedDate = DateTime.Now
                    });
                }
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}