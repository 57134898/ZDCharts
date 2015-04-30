﻿using System;
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
                var fList = db.V_Flows.Where(p => p.IsFinished == COMN.MyVars.No).ToList();
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
                        f.IsFinished = "Y";
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