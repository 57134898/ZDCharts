using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Web;

namespace ZDCharts
{
    public class DBHelper
    {
        private static DbProviderFactory provider;
        //private static DbDataAdapter dda;
        private static string dbConnectString = string.Empty;
        /// <summary>
        ///  DBHelper初始化
        /// </summary>
        /// <param name="cs">连接字符串索引从1开始</param>
        public static void DBHelperInit(int cIndex)
        {
            //从配置文件中取出标示数据库类型的字符串
            string providerName = ConfigurationManager.ConnectionStrings[cIndex].ProviderName;
            dbConnectString = ConfigurationManager.ConnectionStrings[cIndex].ConnectionString;
            //根据上一部的结果工厂创建一个对应的实例
            provider = DbProviderFactories.GetFactory(providerName);
        }
        /// <summary>
        /// Prepare a command for execution
        /// </summary>
        /// <param name="cmd">SqlCommand object</param>
        /// <param name="conn">SqlConnection object</param>
        /// <param name="trans">SqlTransaction object</param>
        /// <param name="cmdType">Cmd type e.g. stored procedure or text</param>
        /// <param name="cmdText">Command text, e.g. Select * from Products</param>
        /// <param name="cmdParms">SqlParameters to use in the command</param>
        private static DbTransaction PrepareCommand(DbCommand cmd, DbConnection conn, DbTransaction trans, CommandType cmdType, string cmdText, DbParameter[] cmdParms)
        {
            if (conn.State != ConnectionState.Open)
                conn.Open();
            cmd.Connection = conn;
            if (trans == null)
                trans = conn.BeginTransaction();
            cmd.Transaction = trans;
            cmd.CommandText = cmdText;
            cmd.CommandType = cmdType;
            if (cmdParms != null)
            {
                cmd.Parameters.Clear();
                foreach (DbParameter parm in cmdParms)
                    cmd.Parameters.Add(parm);
            }
            return trans;
        }

        /// <summary>
        /// 执行SQL语句返回受影响记录条数
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <param name="paras">参数数组</param>
        /// <returns>受影响记录条数</returns>
        public static int ExecuteNonQuery(string sql, DbParameter[] paras)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, paras);
                try
                {
                    int result = cmd.ExecuteNonQuery();
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }

            }
        }

        /// <summary>
        /// 执行SQL语句返回受影响记录条数
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <returns>受影响记录条数</returns>
        public static int ExecuteNonQuery(string sql)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, null);
                try
                {
                    int result = cmd.ExecuteNonQuery();
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 批量执行SQLCMD
        /// </summary>
        /// <param name="LSqlCmdList">SQLCMD</param>
        /// <returns>影响行数</returns>
        public static int ExecuteNonQuery(IList<SqlCmd> LSqlCmdList)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                int r = 0;
                conn.ConnectionString = dbConnectString;
                conn.Open();
                DbTransaction trans = conn.BeginTransaction();
                foreach (SqlCmd item in LSqlCmdList)
                {
                    DbDataAdapter dda = provider.CreateDataAdapter();
                    DbCommand cmd = provider.CreateCommand();
                    cmd.Connection = conn;
                    PrepareCommand(cmd, conn, trans, CommandType.Text, item.CommandText, item.Paras);
                    try
                    {
                        int result = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                        r += result;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        cmd.Parameters.Clear();
                        throw ex;
                    }
                }
                trans.Commit();
                return r;
            }
        }

        /// <summary>
        /// 执行SQL返回表第一行第一列
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <returns>第一行第一列结果的值</returns>
        public static object ExecuteScalar(string sql)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, null);
                try
                {
                    object result = cmd.ExecuteScalar();
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 执行SQL返回表第一行第一列
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <param name="paras">参数数组</param>
        /// <returns>第一行第一列结果的值</returns>
        public static object ExecuteScalar(string sql, DbParameter[] paras)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, paras);
                try
                {
                    object result = cmd.ExecuteScalar();
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 执行SQL语句返回查询结果的DataTable
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <returns>查询结果的DataTable</returns>
        public static DataTable ExecuteDataTable(string sql)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, null);
                dda.SelectCommand = cmd;
                DataTable result = new DataTable();
                try
                {
                    dda.Fill(result);
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 执行SQL语句返回查询结果的DataTable
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <param name="paras">参数数组</param>
        /// <returns>查询结果的DataTable</returns>
        public static DataTable ExecuteDataTable(string sql, DbParameter[] paras)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, paras);
                dda.SelectCommand = cmd;
                DataTable result = new DataTable();
                try
                {
                    dda.Fill(result);
                    trans.Commit();
                    cmd.Parameters.Clear();
                    return result;
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 执行SQL语句返回查询结果的第一行DataRow
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <returns>查询结果的DataTable</returns>
        public static DataRow ExecuteDataRow(string sql)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, null);
                dda.SelectCommand = cmd;
                DataTable result = new DataTable();
                try
                {
                    dda.Fill(result);
                    trans.Commit();
                    cmd.Parameters.Clear();
                    if (result.Rows.Count <= 0)
                    {
                        throw new Exception("无数据"); ;
                    }
                    return result.Rows[0];
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        /// <summary>
        /// 执行SQL语句返回查询结果的DataTable
        /// </summary>
        /// <param name="sql">要执行的SQL语句</param>
        /// <param name="paras">参数数组</param>
        /// <returns>查询结果的DataTable</returns>
        public static DataRow ExecuteDataRow(string sql, DbParameter[] paras)
        {
            using (DbConnection conn = provider.CreateConnection())
            {
                conn.ConnectionString = dbConnectString;
                DbDataAdapter dda = provider.CreateDataAdapter();
                DbCommand cmd = provider.CreateCommand();
                cmd.Connection = conn;
                DbTransaction trans = PrepareCommand(cmd, conn, null, CommandType.Text, sql, paras);
                dda.SelectCommand = cmd;
                DataTable result = new DataTable();
                try
                {
                    dda.Fill(result);
                    trans.Commit();
                    cmd.Parameters.Clear();
                    if (result.Rows.Count <= 0)
                    {
                        throw new Exception("无数据"); ;
                    }
                    return result.Rows[0];
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    cmd.Parameters.Clear();
                    throw ex;
                }
            }
        }

        public class SqlCmd
        {
            public SqlCmd()
            {

            }
            /// <summary>
            /// 初始化
            /// </summary>
            /// <param name="paras">参数列表</param>
            /// <param name="commandText">SQL语句</param>
            public SqlCmd(string commandText, DbParameter[] paras)
            {
                this.Paras = paras;
                this.CommandText = commandText;
            }
            /// <summary>
            ///   参数列表
            /// </summary>
            public DbParameter[] Paras { get; set; }
            /// <summary>
            /// SQL语句
            /// </summary>
            public String CommandText { get; set; }
        }
    }
}