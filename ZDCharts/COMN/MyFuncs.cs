using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace COMN
{
    public class MyFuncs
    {
        public static string GetCodeFromStr(string str, char separator)
        {
            if (string.IsNullOrEmpty(str))
            {
                return string.Empty;
            }
            int end = str.IndexOf(separator);
            return str.Substring(0, end);
        }
    }
}
