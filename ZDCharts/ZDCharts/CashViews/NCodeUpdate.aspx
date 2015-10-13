<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NCodeUpdate.aspx.cs" Inherits="ZDCharts.CashViews.NCodeUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>费用资金项目调整</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />

    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../Content/bootstrap-select.min.css" rel="stylesheet" />
    <link href="../Content/bootstrap-switch/bootstrap3/bootstrap-switch.min.css" rel="stylesheet" />
    <link href="../Content/myStyle.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script src="../Scripts/bootstrap-select.min.js"></script>
    <script src="../Scripts/bootstrap-switch.min.js"></script>
    <script src="../Scripts/spin.min.js"></script>
    <script src="../Scripts/myjs.js"></script>
    <script src="../Scripts/DataTables/jquery.dataTables.min.js"></script>
    <link href="../Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            function loadData(state) {
                $('#dvtable').dataTable({
                    "sPaginationType": "full_numbers",
                    "processing": true,//显示进度条
                    "scrollX": true,//水平滚动条
                    //"bAutoWidth": false,//自动列宽
                    "serverSide": true,//发送服务器请求
                    //列集合
                    "columns": [
                                { "data": "ID" },
                                { "data": "CompanyName" },
                                { "data": "FName" },
                                { "data": "Rmb", 'sClass': "text-right" },
                                { "data": "CreatedDate" },
                                { "data": "RName" },
                                { "data": "ApprovalStatusName" },
                                { "data": null, defaultContent: (state != 10000 ? "<button class='btn btn-default btn-block btn-sm' mark='4'>取消</button>" : "") },
                                { "data": null, defaultContent: (state == 0 ? "<button class='btn btn-default btn-block' mark='3'>修改</button>" : "") },

                                { "data": null, defaultContent: "<button class='btn btn-default btn-block' mark='2'>查询</button>" }
                    ],
                    //汉化
                    "language":
            {
                "sLengthMenu": "每页显示 _MENU_ 条记录",
                "sZeroRecords": "抱歉， 没有找到",
                "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
                "sInfoEmpty": "没有数据",
                "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
                "oPaginate": {
                    "sFirst": "首页",
                    "sPrevious": "上一页",
                    "sNext": "下一页",
                    "sLast": "末页"
                },
                "sZeroRecords": "没有检索到数据",
                "sProcessing": "<img src='../Images/loading.gif'>加载中...",
                "sSearch": "按公司 摘要查找"
            },
                    //请求处理函数
                    "fnServerData": function retrieveData(sSource, aoData, fnCallback) {
                        // 将客户名称加入参数数组
                        //aoData.push( { "name": "customerName", "value": "asdas" } );//添加自己的额外参数
                        $.ajax({
                            "type": "POST",
                            "url": "../handlers/Expense.ashx",
                            "dataType": "json",
                            "data": { Action: 'GetList', p: JSON.stringify(aoData), status: state }, // 以json格式传递
                            "success": function (resp) {
                                //alert(JSON.stringify(resp));
                                fnCallback(resp.data);
                            }
                        });
                    }
                });

            }
            loadData(1000);
        });
    </script>
</head>
<body>
        <div id="tablediv">
            <table id="dvtable" class="display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>公司</th>
                        <th>摘要</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>审批阶段</th>
                        <th>状态</th>
                        <th>取消</th>
                        <th>修改</th>
                        <th>审批查询</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>ID</th>
                        <th>公司</th>
                        <th>摘要</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>审批阶段</th>
                        <th>状态</th>
                        <th>取消</th>
                        <th>修改</th>
                        <th>审批查询</th>
                    </tr>
                </tfoot>
            </table>
        </div>
</body>
</html>
