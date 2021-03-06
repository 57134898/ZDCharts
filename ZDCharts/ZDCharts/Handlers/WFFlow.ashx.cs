﻿using System;
using System.Collections.Generic;
using System.IO;
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
                Guid guid = Guid.Parse(selectCustomerID);
                object oUser = context.Session["user"];
                if (oUser == null)
                {
                    return new Tools.JsonResponse() { Code = "1000", Msg = "session用户过期" };
                }
                MODEL.UserInfo user = (MODEL.UserInfo)oUser;
                //根据部门与角色查找用户可以审批的节点
                var fList = db.V_Flows.Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == user.RoleID && p.CashID == guid && p.F1Result != "N").ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }

        public Tools.JsonResponse GetListByDoc()
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
                var fList = db.V_Flows.Where(p => p.IsFinished == COMN.MyVars.No && p.RoleID == user.RoleID && p.CustomerID == selectCustomerID && p.F1Result != "N").ToList();
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
                    var fList = db.V_Flow_GB_Company.Where(p => p.RoleID == user.RoleID && p.CompanyID.StartsWith("0" + user.AccountBook)).ToList();
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
                var fList = db.V_Flow_GB_Customer.Where(p => p.RoleID == user.RoleID && p.CompanyID == selectCompanyID).OrderBy(p => new { p.Customer, p.Total }).ToList();
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
                //所有行都未通过点则审批结束
                if (result == COMN.MyVars.No)
                {
                    f.IsFinished = "Y";
                    f.Result = result;
                    f.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsRefused;
                }
                else
                {
                    //如果没有下一节,审批结束
                    if (temrow.NextID == 0)
                    {
                        f.IsFinished = "Y";
                        f.Result = result;
                        f.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsAccpeted;
                    }
                    else
                    {
                        f.IsFinished = "N";
                        f.Result = result;
                        f.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsHandling;
                    }
                }
                db.WF_Nodes.Add(new DAL.WF_Nodes()
                {
                    TemRowID = flow.CurNode,
                    FlowID = flow.FID,
                    Result = result,
                    CreatedDate = DateTime.Now,
                    EmpID = this.UserInfo.UserID
                });
                //需要先天剑到NODE后表再赋值
                f.CurNode = temrow.NextID;
                decimal? total = 0;
                foreach (var item in jArr)
                {
                    int fid = int.Parse(item["fid"].ToString());
                    var wf1 = db.WF_Flow1.SingleOrDefault(p => p.FID == fid);
                    wf1.Result = item["result"].ToString().ToUpper();
                    if (item["result"].ToString().ToUpper() == "N")
                    {
                        total += wf1.Rmb;
                    }
                    db.WF_Flow1.Attach(wf1);
                    db.Entry(wf1).State = System.Data.Entity.EntityState.Modified;
                }
                //var total = db.WF_Flow1.Where(p => p.FlowID == curguid && p.Result == "N").Sum(p => p.Rmb);
                var wf2 = db.WF_Flow2.SingleOrDefault(p => p.FlowID == curguid);
                if (wf2.Cash < 0)
                {
                    wf2.Note -= total;
                }
                else
                {
                    if (wf2.Cash - total >= 0)
                    {
                        wf2.Cash -= total;
                    }
                    else
                    {
                        wf2.Note -= (total - wf2.Cash);
                        wf2.Cash = 0;
                    }
                }
                //flow1.Rmb=db.WF_Flow2

                string txtPath = context.Server.MapPath("~\\") + "dblog.txt";
                StreamWriter sw = new StreamWriter(txtPath, false, System.Text.Encoding.Default);
                sw.WriteLine("**********************************************************************************************"); //输出空行 
                db.Database.Log = txt => sw.WriteLine(txt);
                db.SaveChanges();
                sw.WriteLine("***********************************************************************************************"); //输出空行 
                sw.Close();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}