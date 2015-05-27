<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CashUpdate.aspx.cs" Inherits="ZDCharts.CashViews.CashUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
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

    <script src="../Scripts/moment.min.js"></script>
    <script src="../Scripts/daterangepicker.js"></script>
    <link href="../Content/daterangepicker-bs3.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            //alert(1);
            $('#dvtable').dataTable({
                "sPaginationType": "full_numbers",
                "processing": true,//显示进度条
                "scrollX": true,//水平滚动条
                //"bAutoWidth": false,//自动列宽
                "serverSide": true,//发送服务器请求
                "ajax": {
                    "url": "../handlers/CashItem.ashx",
                    "type": "POST",
                    "data": { Action: 'GetList' }
                },
                //列集合
                //"aoColumns": [{ "mDataProp": "ID" }, { "mDataProp": "Name", 'sClass': "text-right" }],
                "columns": [
                            { "data": "ID" },
                            { "data": "CNAME" },
                            { "data": "ExchangeDate" },
                            { "data": "Cash", 'sClass': "text-right" },
                            { "data": "Cash1", 'sClass': "text-right" },
                            { "data": "NCodeC" },
                            { "data": "Note", 'sClass': "text-right" },
                            { "data": "Note1", 'sClass': "text-right" },
                            { "data": "NCodeN" }
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
                         "sFirst": "<button class='btn btn-default'><span class='glyphicon glyphicon-step-backward' aria-hidden='true'></span></button>",
                         "sPrevious": "<button class='btn btn-default'><span class='glyphicon glyphicon-chevron-left' aria-hidden='true'></span></button>",
                         "sNext": "<button class='btn btn-default'><span class='glyphicon glyphicon-chevron-right' aria-hidden='true'></span></button>",
                         "sLast": "<button class='btn btn-default'><span class='glyphicon glyphicon-step-forward' aria-hidden='true'></span></button>"
                     },
                     "sZeroRecords": "没有检索到数据",
                     "sProcessing": "<img src='../Images/loading.gif'>加载中...",
                     "sSearch": "查找"
                 },
                //请求处理函数
                "fnServerData": function retrieveData(sSource, aoData, fnCallback) {
                    // 将客户名称加入参数数组
                    //aoData.push( { "name": "customerName", "value": "asdas" } );//添加自己的额外参数
                    $.ajax({
                        "type": "POST",
                        "url": "../handlers/CashItem.ashx",
                        "dataType": "json",
                        "data": { Action: 'GetList', p: JSON.stringify(aoData) }, // 以json格式传递
                        "success": function (resp) {
                            //alert(JSON.stringify(resp.data));
                            fnCallback(resp.data);
                        }
                    });
                }
            });
            $('table tbody').on('click', 'tr', function () {
                if ($(this).hasClass('selected')) {
                    $(this).removeClass('selected');
                }
                else {
                    $('table tr.selected').removeClass('selected');
                    $(this).addClass('selected');
                    alert("点击的行索引为："+$("table tr.selected td:eq(0)").text());
                }
            });
        });
    </script>
</head>
<body>
    <table id="dvtable" width="100%">
        <thead>
            <tr>
                <th rowspan="2" style="text-align: center;">编号</th>
                <th rowspan="2" style="text-align: center;">客户</th>
                <th rowspan="2" style="text-align: center;">日期</th>
                <th colspan="3" style="text-align: center;">现汇</th>
                <th colspan="3" style="text-align: center;">票据</th>
            </tr>
            <tr>
                <th>预计</th>
                <th>实出</th>
                <th>资金项目</th>
                <th>预计</th>
                <th>实出</th>
                <th>资金项目</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>编号</th>
                <th>客户</th>
                <th>日期</th>
                <th>预计</th>
                <th>实出</th>
                <th>资金项目</th>
                <th>预计</th>
                <th>实出</th>
                <th>资金项目</th>
            </tr>
        </tfoot>
    </table>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
