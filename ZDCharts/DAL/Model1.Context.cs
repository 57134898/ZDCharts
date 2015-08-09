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
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
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
    
        public virtual DbSet<Org_Depts> Org_Depts { get; set; }
        public virtual DbSet<Org_Emps> Org_Emps { get; set; }
        public virtual DbSet<Org_Roles> Org_Roles { get; set; }
        public virtual DbSet<Sys_ApprovalStatus> Sys_ApprovalStatus { get; set; }
        public virtual DbSet<Sys_Menus> Sys_Menus { get; set; }
        public virtual DbSet<WF_TemRows> WF_TemRows { get; set; }
        public virtual DbSet<WF_Tems> WF_Tems { get; set; }
        public virtual DbSet<ACLIENTS> ACLIENTS { get; set; }
        public virtual DbSet<ACONTRACT> ACONTRACT { get; set; }
        public virtual DbSet<AFKXX> AFKXX { get; set; }
        public virtual DbSet<AWX> AWX { get; set; }
        public virtual DbSet<V_ApprovalSteps> V_ApprovalSteps { get; set; }
        public virtual DbSet<V_Emps> V_Emps { get; set; }
        public virtual DbSet<V_Expense> V_Expense { get; set; }
        public virtual DbSet<V_Flow_GB_Company> V_Flow_GB_Company { get; set; }
        public virtual DbSet<V_Flow_GB_Customer> V_Flow_GB_Customer { get; set; }
        public virtual DbSet<V_Flows> V_Flows { get; set; }
        public virtual DbSet<V_Ncode> V_Ncode { get; set; }
        public virtual DbSet<V_UnfinishedContracts> V_UnfinishedContracts { get; set; }
        public virtual DbSet<V_WF3_HVoucher> V_WF3_HVoucher { get; set; }
        public virtual DbSet<vcontracts> vcontracts { get; set; }
        public virtual DbSet<WF_CompanyToTem> WF_CompanyToTem { get; set; }
        public virtual DbSet<WF_Flow1> WF_Flow1 { get; set; }
        public virtual DbSet<WF_Flow2> WF_Flow2 { get; set; }
        public virtual DbSet<WF_Flow3> WF_Flow3 { get; set; }
        public virtual DbSet<WF_Flows> WF_Flows { get; set; }
        public virtual DbSet<WF_Nodes> WF_Nodes { get; set; }
        public virtual DbSet<V_CashItem> V_CashItem { get; set; }
    
        public virtual int AddCashVoucher(ObjectParameter hID, Nullable<decimal> rMB, string eXPL, string vPREPARE, string vCHECK, Nullable<int> vTYPE, ObjectParameter vNO, string dR, string cR, Nullable<int> yEAR, Nullable<int> mONTH, string bCODE, string nCODE)
        {
            var rMBParameter = rMB.HasValue ?
                new ObjectParameter("RMB", rMB) :
                new ObjectParameter("RMB", typeof(decimal));
    
            var eXPLParameter = eXPL != null ?
                new ObjectParameter("EXPL", eXPL) :
                new ObjectParameter("EXPL", typeof(string));
    
            var vPREPAREParameter = vPREPARE != null ?
                new ObjectParameter("VPREPARE", vPREPARE) :
                new ObjectParameter("VPREPARE", typeof(string));
    
            var vCHECKParameter = vCHECK != null ?
                new ObjectParameter("VCHECK", vCHECK) :
                new ObjectParameter("VCHECK", typeof(string));
    
            var vTYPEParameter = vTYPE.HasValue ?
                new ObjectParameter("VTYPE", vTYPE) :
                new ObjectParameter("VTYPE", typeof(int));
    
            var dRParameter = dR != null ?
                new ObjectParameter("DR", dR) :
                new ObjectParameter("DR", typeof(string));
    
            var cRParameter = cR != null ?
                new ObjectParameter("CR", cR) :
                new ObjectParameter("CR", typeof(string));
    
            var yEARParameter = yEAR.HasValue ?
                new ObjectParameter("YEAR", yEAR) :
                new ObjectParameter("YEAR", typeof(int));
    
            var mONTHParameter = mONTH.HasValue ?
                new ObjectParameter("MONTH", mONTH) :
                new ObjectParameter("MONTH", typeof(int));
    
            var bCODEParameter = bCODE != null ?
                new ObjectParameter("BCODE", bCODE) :
                new ObjectParameter("BCODE", typeof(string));
    
            var nCODEParameter = nCODE != null ?
                new ObjectParameter("NCODE", nCODE) :
                new ObjectParameter("NCODE", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("AddCashVoucher", hID, rMBParameter, eXPLParameter, vPREPAREParameter, vCHECKParameter, vTYPEParameter, vNO, dRParameter, cRParameter, yEARParameter, mONTHParameter, bCODEParameter, nCODEParameter);
        }
    
        public virtual int AddCash(Nullable<System.DateTime> exchangeDate, Nullable<decimal> cash, Nullable<decimal> note, Nullable<bool> voucherFlag, string ccode, string hDW, string type)
        {
            var exchangeDateParameter = exchangeDate.HasValue ?
                new ObjectParameter("ExchangeDate", exchangeDate) :
                new ObjectParameter("ExchangeDate", typeof(System.DateTime));
    
            var cashParameter = cash.HasValue ?
                new ObjectParameter("Cash", cash) :
                new ObjectParameter("Cash", typeof(decimal));
    
            var noteParameter = note.HasValue ?
                new ObjectParameter("Note", note) :
                new ObjectParameter("Note", typeof(decimal));
    
            var voucherFlagParameter = voucherFlag.HasValue ?
                new ObjectParameter("VoucherFlag", voucherFlag) :
                new ObjectParameter("VoucherFlag", typeof(bool));
    
            var ccodeParameter = ccode != null ?
                new ObjectParameter("Ccode", ccode) :
                new ObjectParameter("Ccode", typeof(string));
    
            var hDWParameter = hDW != null ?
                new ObjectParameter("HDW", hDW) :
                new ObjectParameter("HDW", typeof(string));
    
            var typeParameter = type != null ?
                new ObjectParameter("Type", type) :
                new ObjectParameter("Type", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("AddCash", exchangeDateParameter, cashParameter, noteParameter, voucherFlagParameter, ccodeParameter, hDWParameter, typeParameter);
        }
    }
}