﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class ContractEntities : DbContext
    {
        public ContractEntities()
            : base("name=ContractEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<V_Flows> V_Flows { get; set; }
        public virtual DbSet<WF_Flow1> WF_Flow1 { get; set; }
        public virtual DbSet<WF_Flows> WF_Flows { get; set; }
        public virtual DbSet<WF_Nodes> WF_Nodes { get; set; }
        public virtual DbSet<WF_TemRows> WF_TemRows { get; set; }
        public virtual DbSet<WF_Tems> WF_Tems { get; set; }
    }
}