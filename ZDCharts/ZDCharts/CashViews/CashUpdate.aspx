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
                            { "data": "NCodeCName" },
                            { "data": "Note", 'sClass': "text-right" },
                            { "data": "Note1", 'sClass': "text-right" },
                            { "data": "NCodeNName" }
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

            ////资金项目按钮事件
            //$('#nocdec-addon').click(function () {
            //    $("#mark").val("rmb");
            //    loadnode();
            //});
            ////资金项目按钮事件
            //$('#nocden-addon').click(function () {
            //    $("#mark").val("note");
            //    loadnode();
            //});

            //function loadnode() {
            //    $("#myModal").modal();
            //    var tLength = $("#nodetable tr").length;
            //    //如果加载过数据则直接显示Modal
            //    if (tLength > 1) {
            //        return;
            //    }
            //    $('#nodetable').dataTable({
            //        "sPaginationType": "full_numbers",
            //        "processing": true,//显示进度条
            //        "serverSide": true,//发送服务器请求
            //        "ajax": {
            //            "url": "../handlers/CashItem.ashx",
            //            "type": "POST",
            //            "data": { Action: 'GetNcodeList' }
            //        },
            //        "columns": [{ "data": "ncode" }, { "data": "nname" }, { "data": null, defaultContent: "<button class='btn btn-default  btn-xs'>选中该条</button>" }],//"bVisible": false  style="display:none,
            //        "columnDefs": [{
            //            "targets": -1,
            //            "data": null,
            //            "defaultContent": "<button>Click!</button>"
            //        }],
            //        //汉化
            //        "language":
            //{
            //    "sLengthMenu": "每页显示 _MENU_ 条记录",
            //    "sZeroRecords": "抱歉， 没有找到",
            //    "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
            //    "sInfoEmpty": "没有数据",
            //    "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
            //    "oPaginate": {
            //        "sFirst": "首页",
            //        "sPrevious": "上一页",
            //        "sNext": "下一页",
            //        "sLast": "末页"
            //    },
            //    "sZeroRecords": "没有检索到数据",
            //    "sProcessing": "<img src='../Images/loading.gif'>加载中...",
            //    "sSearch": "查找"
            //},
            //        //请求处理函数
            //        "fnServerData": function retrieveData(sSource, aoData, fnCallback) {
            //            // 将客户名称加入参数数组
            //            //aoData.push( { "name": "customerName", "value": "asdas" } );//添加自己的额外参数
            //            $.ajax({
            //                "type": "POST",
            //                "url": "../handlers/CashItem.ashx",
            //                "dataType": "json",
            //                "data": { p: JSON.stringify(aoData), Action: 'GetNcodeList' }, // 以json格式传递
            //                "success": function (resp) {
            //                    //alert(JSON.stringify(resp));
            //                    fnCallback(resp.data);
            //                }
            //            });
            //        }
            //    });

            //    ////NCODE表格内按钮点击事件
            //    //$('#nodetable tbody').on('click', 'button', function () {
            //    //    var data = $(this).parents('tr').find('td');
            //    //    //table.row()
            //    //    if ($("#mark").val() == "rmb") {
            //    //        $("#nocdec").val(data.eq(0).html() + ":" + data.eq(1).html());
            //    //        $("#nocdec").attr("code", data.eq(0).html());
            //    //    } else {
            //    //        $("#nocden").val(data.eq(0).html() + ":" + data.eq(1).html());
            //    //        $("#nocden").attr("code", data.eq(0).html());
            //    //    }
            //    //    $("#myModal").modal('hide');
            //    //});
            //}
            $("#savbtn").click(function () {
                var id = $("#dvtable  tr.selected td:eq(0)").text()
                if (id == "") {
                    alert("未选中要修改的数据")
                    return;
                }
                var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('customerCollapse'));
                var postdata = {};
                postdata.ID = $("#dvtable  tr.selected td:eq(0)").text();
                postdata.Cash = $("#rmb").val();
                postdata.Note = $("#note").val();
                //postdata.NCodeC = $("#nocdec").attr("code");
                //postdata.NCodeN = $("#nocden").attr("code");
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/CashItem.ashx',
                    data: { action: 'FormCommit', postdata: JSON.stringify(postdata) },
                    success: function suc(result) {
                        alert(JSON.stringify(result));
                        //请求失败跳转到错误页
                        if (result.code != "0") {
                            redirecToErrorPage(result);
                            return;
                        }

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
            </div>
        </div>
        <div class="panel-body">
            <div class="collapse" id="customerCollapse">
                <!--表单区域-->
                <div class="panel panel-primary">
                    <div class="panel-heading">新增一条记录</div>
                    <div class="panel-body">

                        <form method="post">
                            <table style="width: 100%">
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
                                <%--<tr>
                                    <td style="width: 45%">
                                        <div class="form-group">
                                            <label for="nocdec" class="control-label">现汇资金项目</label>
                                            <div class="input-group">
                                                <input disabled="disabled" id="nocdec" type="text" class="form-control" placeholder="请选现汇资金项目" aria-describedby="nocdec-addon" />
                                                <span class="input-group-btn">
                                                    <button id="nocdec-addon" class="btn btn-default" type="button">查找</button></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 10%"></td>
                                    <td style="width: 45%">
                                        <div class="form-group">
                                            <label for="nocden" class="control-label">票据资金项目</label>
                                            <div class="input-group">
                                                <input disabled="disabled" id="nocden" type="text" class="form-control" placeholder="请选择票据资金项目" aria-describedby="nocden-addon" />
                                                <span class="input-group-btn">
                                                    <button id="nocden-addon" class="btn btn-default" type="button">查找</button></span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>--%>
                            </table>



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
                        <th rowspan="2" class="myTopBorder myLeftBorder myRigthBorder" style="text-align: center;">日期</th>
                        <th colspan="3" class="myTopBorder myRigthBorder" style="text-align: center;">现汇</th>
                        <th colspan="3" class="myTopBorder myRigthBorder" style="text-align: center;">票据</th>
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
                        <th>预计</th>
                        <th>实出</th>
                        <th>资金项目</th>
                        <th>预计</th>
                        <th>实出</th>
                        <th>资金项目</th>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>


</body>
</html>
