using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MODEL
{
    public class Expense
    {
        public string Date { get; set; }
        public string RmbType { get; set; }
        public List<ExpenseRowList> RList { get; set; }
        public string Todo { get; set; }

        public decimal Rmb { get; set; }
    }

    public class ExpenseRowList
    {
        public int RID { get; set; }
        public string Todo { get; set; }
        public string NCode { get; set; }
        public decimal Rmb { get; set; }
    }
}
