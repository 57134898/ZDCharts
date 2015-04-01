using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Tools
{
    public class ABSHttpHandler : IHttpHandler
    {
        public virtual void ProcessRequest(HttpContext context)
        {
            throw new NotImplementedException("ProcessRequest法未实现");
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}