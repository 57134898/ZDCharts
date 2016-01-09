using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace COMN
{
    public class MyVars
    {
        /// <summary>
        /// HVOUCHER前缀
        /// </summary>
        public static string PREFIX_HID = "01";
        //资金数据库名
        public static string CWDB = "";
        //public readonly static string CWDB = "ZJCCS";

        public readonly static string Yes = "Y";
        public readonly static string No = "N";
        public readonly static string Pending = "O";

        /// <summary>
        /// 审批未通过
        /// </summary>
        public readonly static int ApprovalStatus_IsRefused = -1;
        /// <summary>
        /// 审批已申请
        /// </summary>
        public readonly static int ApprovalStatus_IsStarted = 0;
        /// <summary>
        /// 审批中
        /// </summary>
        public readonly static int ApprovalStatus_IsHandling = 100;
        /// <summary>
        /// 审批通过
        /// </summary>
        public readonly static int ApprovalStatus_IsAccpeted = 1000;
        /// <summary>
        /// 业务处理完成
        /// </summary>
        public readonly static int ApprovalStatus_IsFinished = 10000;
        /// <summary>
        /// 取消
        /// </summary>
        public readonly static int ApprovalStatus_Canceled = 100000;
    }
}
