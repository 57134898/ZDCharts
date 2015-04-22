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
                var fList = db.V_Flows.Where(p => p.IsFinished == COMN.MyVars.Yes).ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }
        public Tools.JsonResponse Agree()
        {
            return DoApprove(COMN.MyVars.Yes);
        }

        public Tools.JsonResponse Refuse()
        {
            return DoApprove(COMN.MyVars.No);
        }

        private Tools.JsonResponse DoApprove(string result)
        {
            string curnodeid = context.Request.Form["curnodeid"];
            if (curnodeid == null || curnodeid == "")
            {
                return new Tools.JsonResponse() { Code = "9000", Msg = "curnodeid不能为空" };
            }

            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                Guid curguid = Guid.Parse(curnodeid);
                var flow = db.V_Flows.SingleOrDefault(p => p.FID == curguid);
                if (flow == null)
                {
                    return new Tools.JsonResponse() { Code = "9001", Msg = "未找到节点" };
                }
                else
                {
                    var temrow = db.WF_TemRows.SingleOrDefault(p => p.TemID == flow.TemID && p.RID == flow.RID);
                    if (temrow == null)
                    {
                        return new Tools.JsonResponse() { Code = "9001", Msg = "未找审批阶段" };
                    }
                    else
                    {
                        var f = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                        if (f == null)
                        {
                            return new Tools.JsonResponse() { Code = "9001", Msg = "未找到待审批数据" };
                        }
                        else
                        {
                            if (temrow.NextID < 0)
                            {
                                f.IsFinished = result;
                            }
                            f.CurNode = temrow.NextID;
                        }
                    }
                    db.WF_Nodes.Add(new DAL.WF_Nodes()
                    {
                        TemRowID = flow.RID,
                        Result = result,
                        CreatedDate = DateTime.Now
                    });
                    db.SaveChanges();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
                }
            }
        }
    }
}