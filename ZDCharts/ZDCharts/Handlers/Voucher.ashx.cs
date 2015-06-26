using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Handlers
{
    /// <summary>
    /// Voucher 的摘要说明
    /// </summary>
    public class Voucher : Tools.ABSHttpHandler
    {
        public Tools.JsonResponse AddExpenseVoucher()
        {

            string str = this.GetParam("postdata");
            JObject postdatajson = JObject.Parse(str);
            int id = int.Parse(postdatajson.GetValue("ID").ToString());
            decimal rmb1 = decimal.Parse(postdatajson.GetValue("Cash").ToString());
            decimal note1 = decimal.Parse(postdatajson.GetValue("Note").ToString());
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var flow = db.V_Expense.SingleOrDefault(p => p.ID == id);
                DAL.WF_Flow3 wf3 = db.WF_Flow3.SingleOrDefault(p => p.FlowID == flow.FID);
                //TODO 生成凭证到资金池

                //添加现汇申请凭证
                if (flow.Rmb > 0)
                {
                    var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    db.AddCashVoucher(hid, rmb1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 3, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                    wf3.VoucherID = hid.Value.ToString();
                    wf3.Rmb1 = rmb1;
                    //Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString() + "<br/>" + hid_v + "||" + vno_v.ToString());
                }
                //添加票据申请凭证
                if (flow.Note > 0)
                {
                    var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                    var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                    db.AddCashVoucher(hid, note1, flow.FName, this.UserInfo.UserName, this.UserInfo.UserName, 4, vno, "100801", "1010", DateTime.Now.Year, DateTime.Now.Month, "01", flow.CashItem);
                    wf3.VoucherID1 = hid.Value.ToString();
                    wf3.Note1 = note1;
                }
                //标记审批状态为已经处理完成
                var wf = db.WF_Flows.SingleOrDefault(p => p.FID == flow.FID);
                if (wf != null)
                {
                    wf.ApprovalStatus = COMN.MyVars.ApprovalStatus_IsFinished;
                }
                int result = db.SaveChanges();
                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = result };
            }
        }
    }
}