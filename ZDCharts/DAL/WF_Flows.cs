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
    
    public partial class WF_Flows
    {
        public System.Guid FID { get; set; }
        public string FName { get; set; }
        public Nullable<int> CurNode { get; set; }
        public string IsFinished { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string Creater { get; set; }
        public Nullable<System.Guid> TemID { get; set; }
        public string Result { get; set; }
        public string DocType { get; set; }
        public int ID { get; set; }
    }
}
