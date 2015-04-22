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
                var fList = db.V_Flows.ToList();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = fList };
            }
        }
        public Tools.JsonResponse Agree()
        {
            string curnodeid = context.Request.Form["curnodeid"];
            if (curnodeid == null || curnodeid == "")
            {
                return new Tools.JsonResponse() { Code = "9000", Msg = "curnodeid不能为空" };
            }
            DAL.WF_Nodes node = new DAL.WF_Nodes();
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var flow = db.V_Flows.SingleOrDefault(p => p.FID == Guid.Parse(curnodeid));
                if (flow == null)
                {
                    return new Tools.JsonResponse() { Code = "9001", Msg = "未找到节点" };
                }
                else
                {

                    node.TemRowID = 10;
                    node.Result = "Y";
                    node.TemRowID = 3;
                    db.WF_Nodes.Add(node);
                    db.SaveChanges();
                    return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
                }
            }
        }
        public Tools.JsonResponse Refuse()
        {
            string curnodeid = context.Request.Form["curnodeid"];
            if (curnodeid == null || curnodeid == "")
            {
                return new Tools.JsonResponse() { Code = "9000", Msg = "curnodeid不能为空" };
            }
            DAL.WF_Nodes node = new DAL.WF_Nodes();
            node.TemRowID = 10;
            node.Result = "N";
            node.TemRowID = 3;
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                db.WF_Nodes.Add(node);
                db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功" };
            }
        }
    }
}