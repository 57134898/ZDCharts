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
            //[{"fid":"3","result":"Y"},{"fid":"4","result":"N"}]
            Newtonsoft.Json.Linq.JArray jArr = Newtonsoft.Json.Linq.JArray.Parse(jsonStr);
            if (jArr.Count <= 0)
                return new Tools.JsonResponse() { Code = "9001", Msg = "没有审批数据" };
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                //获取F1ID
                int f1id = int.Parse(jArr[0]["fid"].ToString());
                //审批结果 全部拒绝为N 部分通过为Y
                var resultOjb = jArr.FirstOrDefault(p => p["result"].ToString() == "Y");
                string result = "";
                if (resultOjb == null)
                {
                    result = COMN.MyVars.No;
                }
                else
                {
                    result = COMN.MyVars.Yes;
                }
                //通过WF1行ID查找FLOWID
                var flow1 = db.WF_Flow1.FirstOrDefault(p => p.FID == f1id);
                Guid curguid = Guid.Parse(flow1.FlowID.ToString());
                //查找待审批工作流节点
                var flow = db.WF_Flows.SingleOrDefault(p => p.FID == curguid);
                if (flow == null)
                    return new Tools.JsonResponse() { Code = "9001", Msg = "未找到节点" };
                //查找待审批阶段
                var temrow = db.WF_TemRows.SingleOrDefault(p => p.TemID == flow.TemID && p.RID == flow.CurNode);
                if (temrow == null)
                    return new Tools.JsonResponse() { Code = "9002", Msg = "未找审批阶段" };
                //查找待审批数据
                var f = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                if (f == null)
                    return new Tools.JsonResponse() { Code = "9003", Msg = "未找到待审批数据" };
                //如果没有下一节或者所有行都未通过点则审批结束
                if (temrow.NextID == 0 || result == COMN.MyVars.No)
                {
                    f.IsFinished = "Y";
                    f.Result = result;
                }
                else
                {
                    f.IsFinished = "N";
                    f.Result = result;
                }
                f.CurNode = temrow.NextID;
                db.WF_Nodes.Add(new DAL.WF_Nodes()
                {
                    TemRowID = flow.CurNode,
                    FlowID = flow.FID,
                    Result = result,
                    CreatedDate = DateTime.Now
                });
                foreach (var item in jArr)
                {
                    int fid = int.Parse(item["fid"].ToString());
                    var wf1 = db.WF_Flow1.SingleOrDefault(p => p.FID == fid);
                    wf1.Result = item["result"].ToString().ToUpper();
                    db.WF_Flow1.Attach(wf1);
                    db.Entry(wf1).State = System.Data.Entity.EntityState.Modified;
                }
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}