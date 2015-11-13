using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MODEL
{
    public class CashItem
    {
        public int ID { get; set; }
        public decimal Cash { get; set; }
        public decimal Note { get; set; }
        public decimal MNote { get; set; }
        public string NCodeC { get; set; }
        public string NCodeN { get; set; }
    }
}
