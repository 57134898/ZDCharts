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
            function loadData(state) {
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
                                { "data": "CNAME", "sWidth": "300px" },
                                { "data": "ExchangeDate" },
                                { "data": "ContractTotal", 'sClass': "text-right" },
                                { "data": "Cash", 'sClass': "text-right" },
                                { "data": "Cash1", 'sClass': "text-right" },
                                { "data": "NCodeCName" },
                                { "data": "Note", 'sClass': "text-right" },
                                { "data": "Note1", 'sClass': "text-right" },
                                { "data": "NCodeNName" },
                                { "data": "ApprovalStatusName" },
                                { "data": null, defaultContent: (state == 1000 ? "<button class='btn btn-default  btn-sm'>确定</button>" : "") }
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
                            "data": { Action: 'GetList', p: JSON.stringify(aoData), status: state }, // 以json格式传递
                            "success": function (resp) {
                                //alert(JSON.stringify(resp.data));
                                fnCallback(resp.data);
                            }
                        });
                    }
                });
            }
            //默认加载 审批完成但未生成凭证的数据 
            loadData(1000);
            //工具栏样式设置
            $('[data-toggle="tooltip"]').tooltip();
            //添加按钮事件
            $('#toolbtn_add').click(function () {
                $('#customerCollapse').collapse('toggle');
            });
            $('#toolbtn_refresh').click(function () {
                location.reload();
            });
            $('#dvtable tbody').on('click', 'tr', function () {
                if ($(this).hasClass('selected')) {
                    $(this).removeClass('selected');
                }
                else {
                    $('table tr.selected').removeClass('selected');
                    $(this).addClass('selected');
                    //alert("点击的行索引为：" + $("table tr.selected td:eq(0)").text());
                }
            });
            //ncode表格内按钮点击事件
            $('#dvtable tbody').on('click', 'button', function () {
                var data = $(this).parents('tr').find('td');
                //alert(111);
                $("#myitemModal").modal('show');
                $("#rmb").val(data.eq(4).html());
                $("#note").val(data.eq(7).html());
                $("#mark").val(data.eq(0).html());
                //$("#myitemModal").modal('hide');
            });
            //审批状态下拉菜单事件
            $("#dropdownMenu li a").click(function () {
                $("#dropdownMenuTitleBtn").text($(this).text());

                $('#dvtable').dataTable().fnDestroy()
                loadData($(this).attr("sid"));
            });

            $("#commitBtn").click(function () {
                //var id = $("#dvtable  tr.selected td:eq(0)").text()
                //if (id == "") {
                //    alert("未选中要修改的数据")
                //    return;
                //}
                var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('myitemModal'));
                var postdata = {};
                postdata.ID = $("#mark").val();//$("#dvtable  tr.selected td:eq(0)").text();
                postdata.Cash = Number($("#rmb").val());
                postdata.Note = Number($("#note").val());
                //postdata.NCodeC = $("#nocdec").attr("code");
                //postdata.NCodeN = $("#nocden").attr("code");
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/CashItem.ashx',
                    data: { action: 'FormCommit', postdata: JSON.stringify(postdata) },
                    success: function suc(result) {
                        //alert(JSON.stringify(result));
                        //请求失败跳转到错误页
                        if (result.code == "9100") {
                            alert(result.msg + "\r\n" + result.data);
                            spinner1.stop();
                            return;
                        }
                        location.reload();
                        spinner1.stop();
                    },
                    dataType: 'JSON'
                });
            });//savbtn click结束
        });//$.ready方法结束
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-heading">
            <!--  工具栏-->
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
                <div class="btn-group" role="group">
                    <button id="dropdownMenuTitleBtn" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        &nbsp;审批通过&nbsp;
                       <span class="caret"></span>
                    </button>
                    <ul id="dropdownMenu" class="dropdown-menu" role="menu">
                        <li><a href="javascript:void(0)" sid="0">已申请&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="100">审批中&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="1000">审批通过&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="10000">已生成凭证</a></li>
                        <li><a href="javascript:void(0)" sid="-1">审批未通过</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div class="collapse" id="customerCollapse">
                <!--表单区域-->
                <div class="panel panel-primary">
                    <div class="panel-heading">新增一条记录</div>
                    <div class="panel-body">
                        <form method="post">
                            <%--                           <table style="width: 100%">
                                <tr>
                                    <td style="width: 45%">
                                        <div class="form-group">
                                            <label for="rmb" class="control-label">实际支出现汇</label>
                                            <input id="rmb" type="number" class="form-control" placeholder="请现汇金额" />
                                        </div>
                                    </td>
                                    <td style="width: 10%"></td>
                                    <td style="width: 45%">
                                        <div class="form-group">
                                            <label for="note" class="control-label">实际支出票据</label>
                                            <input id="note" type="number" class="form-control" placeholder="请票据金额" />
                                        </div>
                                    </td>
                                </tr>
                            </table>--%>
                        </form>
                    </div>
                    <div class="panel-footer">
                        <button id="savbtn" type="button" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                        <button id="canbtn" type="button" class="btn btn-default">&nbsp;&nbsp;&nbsp;取&nbsp;消&nbsp;&nbsp;&nbsp;</button>
                    </div>
                </div>
            </div>
            <table id="dvtable" class="display compact cell-border" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">编号</th>
                        <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">客户</th>
                        <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">日期</th>
                        <th rowspan="2" class="myTopBorder myLeftBorder myRigthBorder" style="text-align: center;">合同付款金额</th>
                        <th colspan="3" class="myTopBorder myRigthBorder" style="text-align: center;">现汇</th>
                        <th colspan="3" class="myTopBorder myRigthBorder" style="text-align: center;">票据</th>
                        <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">审批状态</th>
                        <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">生成凭证</th>
                    </tr>
                    <tr>
                        <th class="myRigthBorder">预计</th>
                        <th class="myRigthBorder">实出</th>
                        <th class="myRigthBorder">资金项目</th>
                        <th class="myRigthBorder">预计</th>
                        <th class="myRigthBorder">实出</th>
                        <th class="myRigthBorder">资金项目</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>编号</th>
                        <th>客户</th>
                        <th>日期</th>
                        <th>合同付款金额</th>
                        <th>预计</th>
                        <th>实出</th>
                        <th>资金项目</th>
                        <th>预计</th>
                        <th>实出</th>
                        <th>资金项目</th>
                        <th>审批状态</th>
                        <th>生成凭证</th>
                    </tr>

                </tfoot>
            </table>
        </div>
    </div>

    <!--确认弹出层-->
    <div class="modal fade" id="myitemModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">金额确认</h4>
                </div>
                <div class="modal-body">
                    <div class="panel panel-info">
                        <%--<div class="panel-heading">新增一条记录</div>--%>
                        <div class="panel-body">
                            <input type="hidden" id="mark" />
                            <div class="form-group">
                                <label for="rmb" class="control-label">实际支出现汇</label>
                                <input id="rmb" type="number" class="form-control glyphicon-align-right" placeholder="请现汇金额" />
                            </div>
                            <div class="form-group">
                                <label for="note" class="control-label">实际支出票据</label>
                                <input id="note" type="number" class="form-control" placeholder="请票据金额" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="commitBtn" type="button" data-toggle="popover" class="btn btn-primary btn-lg">生成凭证</button>
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
