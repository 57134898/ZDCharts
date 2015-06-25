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
                                { "data": null, defaultContent: (state == 1000 ? "<button class='btn btn-default btn-block btn-sm' mark='1'>确定</button>" : "") },
                                { "data": null, defaultContent: "<button class='btn btn-default btn-block btn-sm' mark='2'>查询</button>" }
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
            }
            //默认加载 审批完成但未生成凭证的数据 
            loadData(1000);
            //表格内按钮点击事件 查看审批进度按钮
            $('#dvtable tbody').on('click', "button[mark='2']", function () {
                var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('progressModalBody'));
                var data = $(this).parents('tr').find('td');
                $("#progressModal").modal('show');
                //data.eq(0).html()
                //progressBody
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/WFFlow1.ashx',
                    data: { action: 'GetStepList', flowid: data.eq(0).html() },
                    success: function suc(result) {
                        //alert(JSON.stringify(result));
                        //请求失败跳转到错误页
                        if (result.code == "0") {
                            $("#progressBody").empty();
                            var sHtml = "";
                            for (var i = 0; i < result.data.length; i++) {
                                //alert(result.data[i].ID);
                                //class="active"
                                if (result.data[i].RID == result.msg) {
                                    sHtml += "<tr class='info'>";
                                }
                                else {
                                    if (result.data[i].Result == "Y") {
                                        sHtml += "<tr class='success'>";
                                    }
                                    else if (result.data[i].Result == "N") {
                                        sHtml += "<tr class='danger'>";
                                    }
                                    else {
                                        sHtml += "<tr>";
                                    }
                                }
                                sHtml += "<td>" + result.data[i].RID + "</td>";
                                sHtml += "<td>" + result.data[i].RName + "</td>";
                                sHtml += "<td>" + result.data[i].Result + "</td>";
                                sHtml += "</tr>";
                            }

                            $("#progressBody").append(sHtml);
                        }
                        spinner1.stop();
                    },
                    dataType: 'JSON'
                });
            });
            //表格内按钮点击事件 生成凭证按钮
            $('#dvtable tbody').on('click', 'button[mark='1']', function () {
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
                <%--                <div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增一条记录"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_update" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="修改选中记录"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></button>
                    <button id="toolbtn_del" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="删除选中记录"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_refresh" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="刷新"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
                </div>--%>
                <div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增一条记录"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                    <button id="toolbtn_refresh" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="刷新"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="dropdownMenuTitleBtn" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        已申请&nbsp;&nbsp;&nbsp;&nbsp;
                       <span class="caret"></span>
                    </button>
                    <ul id="dropdownMenu" class="dropdown-menu" role="menu">
                        <li><a href="javascript:void(0)" sid="0">已申请&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="100">审批中&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="1000">审批通过&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="10000">已生成凭证</a></li>
                        <li><a href="javascript:void(0)" sid="100000">取消&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="-1">审批未通过</a></li>
                    </ul>
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
                        <th>审批查询</th>
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
                        <th>审批查询</th>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <%--审批进度弹出层--%>
    <div class="modal fade" id="progressModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <%--<div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="progressModalLabel">审批进度</h4>
                </div>--%>
                <div class="modal-body" id="progressModalBody">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>编号</th>
                                <th>当前位置</th>
                                <th>结果</th>
                            </tr>
                        </thead>
                        <tbody id="progressBody">
                        </tbody>
                    </table>
                </div>
                <%--<div class="modal-footer">
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>--%>
            </div>
        </div>
    </div>
</body>
</html>
