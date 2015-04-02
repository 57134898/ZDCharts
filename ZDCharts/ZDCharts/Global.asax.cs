using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace ZDCharts
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            //DBHelper.DBHelperInit(1);
            DBHelper.DBHelperInit(2);
        }
    }
}