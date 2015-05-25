using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ZDCharts
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            object user = Session["user"];
            if (user != null)
            {
                this.userinfoinput.Value = Newtonsoft.Json.JsonConvert.SerializeObject(user);
            }
        }
    }
}