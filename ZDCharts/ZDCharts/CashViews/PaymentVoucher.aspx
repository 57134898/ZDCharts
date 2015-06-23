<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentVoucher.aspx.cs" Inherits="ZDCharts.CashViews.PaymentVoucher" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>资金申请</title>
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
        $(document).ready(function () {
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
                            { "data": null, defaultContent: "<button class='btn btn-default  btn-sm'>确定</button>" }
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
                        "url": "../handlers/Expense.ashx",
                        "dataType": "json",
                        "data": { Action: 'GetList', p: JSON.stringify(aoData) }, // 以json格式传递
                        "success": function (resp) {
                            //alert(JSON.stringify(resp));
                            fnCallback(resp.data);
                        }
                    });
                }
            });

            $('#dvtable tbody').on('click', 'button', function () {
                var data = $(this).parents('tr').find('td');
                $.ajax({
                    "type": "POST",
                    "url": "../handlers/Voucher.ashx",
                    "dataType": "json",
                    "data": { Action: 'AddExpenseVoucher', id: data.eq(0).html() }, // 以json格式传递
                    "success": function (result) {
                        alert(JSON.stringify(result));

                        location.reload();
                    }
                });
                //alert(data.eq(0).html());
            });


            //选中行变色 单行
            $('table tbody').on('click', 'tr', function () {
                if ($(this).hasClass('selected')) {
                    $(this).removeClass('selected');
                }
                else {
                    $('table tr.selected').removeClass('selected');
                    $(this).addClass('selected');
                }
            });
            //刷新按钮
            $('#toolbtn_refresh').click(function () {
                location.reload();
            });
            //添加按钮

            //浏览按钮
            $('#toolbtn_stateview').click(function () {
                var table = $('#dvtable').DataTable();
                table.column(1).visible(false);

            });

            //工具栏按钮tooltip设置
            $('[data-toggle="tooltip"]').tooltip();

        });
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-heading">
            <!--工具栏-->
            <div class="btn-toolbar" role="toolbar">
                <!--工具栏分组-->
                <div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增一条记录"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_update" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="修改选中记录"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></button>
                    <button id="toolbtn_del" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="删除选中记录"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_refresh" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="刷新"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <table id="dvtable" class="display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>流水号</th>
                        <th>公司</th>
                        <th>摘要</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>审批阶段</th>
                        <th>生成凭证</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>流水号</th>
                        <th>公司</th>
                        <th>摘要</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>审批阶段</th>
                        <th>生成凭证</th>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>

</body>
</html>
