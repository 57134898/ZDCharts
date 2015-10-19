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
                    //所有行都未通过点则审批结束/
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

        public Tools.JsonResponse CancelDoc()
        {
            int id = int.Parse(this.GetParam("id"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var curNode = db.WF_Flows.SingleOrDefault(p => p.ID == id);
                curNode.ApprovalStatus = COMN.MyVars.ApprovalStatus_Canceled;
                int result = db.SaveChanges();
                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = curNode.CurNode.ToString(),
                    Data = result
                };
            }
        }
        public Tools.JsonResponse GetModelByID()
        {
            int id = int.Parse(this.GetParam("id"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var curNode = db.WF_Flows.SingleOrDefault(p => p.ID == id);
                var vflow = db.V_Flows.Where(p => p.FID == curNode.FID).ToList();
                var vcashitem = db.V_CashItem.SingleOrDefault(p => p.FlowID == curNode.FID);

                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = curNode.CurNode.ToString(),
                    Data = vcashitem,
                    Data0 = vflow
                };
            }
        }
        public Tools.JsonResponse GetModelByID_Expense()
        {
            int id = int.Parse(this.GetParam("id"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var curNode = db.WF_Flows.SingleOrDefault(p => p.ID == id);
                var vexp = db.V_Expense.SingleOrDefault(p => p.FID == curNode.FID);
                var vvexpr = db.V_ExpenseRows.Where(p => p.FID == curNode.FID).ToList();

                return new Tools.JsonResponse()
                {
                    Code = "0",
                    Msg = curNode.CurNode.ToString(),
                    Data = vexp,
                    Data0 = vvexpr
                };
            }
        }


        public Tools.JsonResponse DoUpdateDoc()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                int id = int.Parse(this.GetParam("id"));
                string jsonstr = context.Request.Form["PayInfo"];
                MODEL.PayInfo payinfo = (MODEL.PayInfo)Newtonsoft.Json.JsonConvert.DeserializeObject(jsonstr, typeof(MODEL.PayInfo));
                //TODO 修改保存 未完------------------------------------------------------
                var flow = db.WF_Flows.SingleOrDefault(p => p.ID == id);
                var wf1 = db.WF_Flow1.Where(p => p.FlowID == flow.FID).ToList();
                var wf2 = db.WF_Flow2.SingleOrDefault(p => p.FlowID == flow.FID);
                wf2.NCodeC = payinfo.NCodeC;
                wf2.NCodeN = payinfo.NCodeC;

                if (flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsStarted)
                {
                    wf2.Cash = payinfo.Rmb;
                    wf2.Note = payinfo.Note;
                    db.WF_Flow1.RemoveRange(wf1);
                    foreach (var item in payinfo.List)
                    {
                        db.WF_Flow1.Add(new DAL.WF_Flow1()
                        {
                            FlowID = flow.FID,
                            CashID = wf2.CashID,
                            HCode = item.HCODE,
                            Rmb = item.CurRmb,
                            XSHcode = item.XSHCODE,
                            Result = COMN.MyVars.Pending
                        });
                    }
                }
                if (flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsFinished)
                {
                    string sql = string.Empty;
                    if (!string.IsNullOrEmpty(wf2.CashVoucherID))
                    {
                        sql += string.Format(@"  UPDATE {0}.dbo.ivoucher SET [ncode] ='{1}' WHERE 1=1 AND HID ='{2}'", COMN.MyVars.CWDB, payinfo.NCodeC, wf2.CashVoucherID);
                    }
                    if (!string.IsNullOrEmpty(wf2.NoteVoucherID))
                    {
                        sql += string.Format(@"  UPDATE {0}.dbo.ivoucher SET [ncode] ='{1}' WHERE 1=1 AND HID ='{2}' ", COMN.MyVars.CWDB, payinfo.NCodeC, wf2.NoteVoucherID);
                    }
                    if (!string.IsNullOrEmpty(sql))
                    {
                        int result_sql = DBHelper.ExecuteNonQuery(sql);
                    }
                }
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
        public Tools.JsonResponse DoUpdateDoc_Expense()
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                int id = int.Parse(this.GetParam("id"));
                string jsonStr = context.Request.Form["formdata"];
                var formdata = Newtonsoft.Json.JsonConvert.DeserializeObject<MODEL.Expense>(jsonStr);
                var flow = db.WF_Flows.SingleOrDefault(p => p.ID == id);
                var wf3 = db.WF_Flow3.SingleOrDefault(p => p.FlowID == flow.FID);
                //var wf4 = db.WF_Flow4.Where(p => p.FlowID == flow.FID);
                if (flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsStarted)
                {
                    flow.FName = formdata.Todo;
                    wf3.Rmb = formdata.Rmb;
                    wf3.RmbType = formdata.RmbType;
                    db.WF_Flow4.RemoveRange(db.WF_Flow4.Where(p => p.FlowID == flow.FID));

                    foreach (var item in formdata.RList)
                    {
                        db.WF_Flow4.Add(new DAL.WF_Flow4()
                        {
                            FlowID = wf3.FlowID,
                            NCode = COMN.MyFuncs.GetCodeFromStr(item.NCode, '-'),
                            Result = "O",
                            Rmb = item.Rmb,
                            Todo = item.Todo
                        });
                    }
                }
                if (flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsAccpeted
                    || flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsHandling
                    || flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsFinished)
                {
                    foreach (var item in formdata.RList)
                    {
                        var row = db.WF_Flow4.SingleOrDefault(p => p.ID == item.RID);
                        if (row != null)
                        {
                            row.NCode = COMN.MyFuncs.GetCodeFromStr(item.NCode, '-');
                        }
                        if (flow.ApprovalStatus == COMN.MyVars.ApprovalStatus_IsFinished)
                        {
                            string sql = string.Empty;
                            var _wf4row = db.WF_Flow4.SingleOrDefault(p => p.ID == item.RID);
                            sql += string.Format(@"  UPDATE {0}.dbo.ivoucher SET [ncode] ='{1}' WHERE HID='{2}'  AND INO ='{3}'",
                                new object[] { COMN.MyVars.CWDB, COMN.MyFuncs.GetCodeFromStr(item.NCode, '-'), wf3.VoucherID, _wf4row.VoucherRowID });
                            if (!string.IsNullOrEmpty(sql))
                            {
                                int result_sql = DBHelper.ExecuteNonQuery(sql);
                            }
                        }
                    }
                }

                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}