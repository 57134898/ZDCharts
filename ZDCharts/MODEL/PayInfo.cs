using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MODEL
{
    public class PayInfo
    {
        public string CustomerID { get; set; }
        public string PayDate { get; set; }
        public decimal Rmb { get; set; }
        public decimal Note { get; set; }
        public string ComanyID { get; set; }
        public List<NonRmb> List { get; set; }

    }
}
