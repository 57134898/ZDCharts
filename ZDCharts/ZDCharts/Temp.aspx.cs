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
                string hid_v = string.Empty;
                int vno_v = 0;
                var hid = new System.Data.Entity.Core.Objects.ObjectParameter("HID", typeof(string));
                var vno = new System.Data.Entity.Core.Objects.ObjectParameter("VNO", typeof(int));
                db.AddCashVoucher(hid, 1500, "啦啦啦啦", "赵六", "赵六", 0, vno, "1003", "100101", 2015, 6, "0110", "02001");
                hid_v = hid.Value.ToString();
                vno_v = int.Parse(vno.Value.ToString());
                db.AddCashVoucher(hid, 1500, "啊啊啊啊", "赵六", "赵六", 1, vno, "1003", "100101", 2015, 6, "0110", "02001");
                Response.Write(hid.Value.ToString() + "||" + vno.Value.ToString() + "<br/>" + hid_v + "||" + vno_v.ToString());
            }
        }
    }
}