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
            int id = int.Parse(this.GetParam("id"));
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var flow = db.V_Expense.SingleOrDefault(p => p.ID == id);
                //TODO 生成凭证到资金池

                return new Tools.JsonResponse() { Code = "0", Msg = "操作成功", Data = "" };
            }
        }
    }
}