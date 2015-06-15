using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts
{
    public partial class Temp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            using (DAL.ContractEntities db = new DAL.ContractEntities())
            {
                var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                db.AddCashVoucher(hid, 100, "啦啦啦啦", "赵六", "赵六", 1, vno, "1001", "1002", 2015, 6, "0110");

                Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString());
            }
        }
    }
}