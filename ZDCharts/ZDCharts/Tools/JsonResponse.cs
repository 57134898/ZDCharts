using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ZDCharts.Tools
{
    public class JsonResponse
    {
        public string Code { get; set; }
        public string Msg { get; set; }
        //public HttpContext context { get; set; }
        public object Data { get; set; }
        public object Data1 { get; set; }
        public object Data0 { get; set; }
    }
}