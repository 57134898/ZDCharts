//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class V_Expense
    {
        public System.Guid FID { get; set; }
        public string FName { get; set; }
        public Nullable<int> CurNode { get; set; }
        public string IsFinished { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string Creater { get; set; }
        public Nullable<System.Guid> TemID { get; set; }
        public string TemName { get; set; }
        public string TemIsEnabled { get; set; }
        public int RID { get; set; }
        public string RName { get; set; }
        public int NextID { get; set; }
        public int PreID { get; set; }
        public string NextNode { get; set; }
        public string PreNode { get; set; }
        public string DeptID { get; set; }
        public string RoleID { get; set; }
        public string DeptName { get; set; }
        public string RoleName { get; set; }
        public string Result { get; set; }
        public Nullable<System.DateTime> ExchangeDate { get; set; }
        public Nullable<decimal> Rmb { get; set; }
        public string CompanyID { get; set; }
        public string CashItem { get; set; }
        public string CashType { get; set; }
        public string VoucherID { get; set; }
        public string DocType { get; set; }
        public string CompanyName { get; set; }
        public int ID { get; set; }
        public Nullable<int> ApprovalStatus { get; set; }
        public string ApprovalStatusName { get; set; }
    }
}
