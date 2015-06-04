﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Expense.aspx.cs" Inherits="ZDCharts.CashViews.Expense" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            //$('#dvtable').dataTable({
            //    "sPaginationType": "full_numbers",
            //    "processing": true,//显示进度条
            //    "scrollX": true,//水平滚动条
            //    //"bAutoWidth": false,//自动列宽
            //    "serverSide": true,//发送服务器请求
            //    "ajax": {
            //        "url": "../handlers/Customer.ashx",
            //        "type": "POST",
            //        "data": { Action: 'GetContractListByCompany' }
            //    },
            //    //列集合
            //    //"aoColumns": [{ "mDataProp": "ID" }, { "mDataProp": "Name", 'sClass': "text-right" }],
            //    "columns": [
            //                { "data": "Customer" },
            //                { "data": "Total" },
            //                { "data": "CreatedDate" },
            //                { "data": "IsFinished" }
            //    ],
            //    //汉化
            //    "language":
            //     {
            //         "sLengthMenu": "每页显示 _MENU_ 条记录",
            //         "sZeroRecords": "抱歉， 没有找到",
            //         "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
            //         "sInfoEmpty": "没有数据",
            //         "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
            //         "oPaginate": {
            //             "sFirst": "<button class='btn btn-default'><span class='glyphicon glyphicon-step-backward' aria-hidden='true'></span></button>",
            //             "sPrevious": "<button class='btn btn-default'><span class='glyphicon glyphicon-chevron-left' aria-hidden='true'></span></button>",
            //             "sNext": "<button class='btn btn-default'><span class='glyphicon glyphicon-chevron-right' aria-hidden='true'></span></button>",
            //             "sLast": "<button class='btn btn-default'><span class='glyphicon glyphicon-step-forward' aria-hidden='true'></span></button>"
            //         },
            //         "sZeroRecords": "没有检索到数据",
            //         "sProcessing": "<img src='../Images/loading.gif'>加载中...",
            //         "sSearch": "查找"
            //     },
            //    //请求处理函数
            //    "fnServerData": function retrieveData(sSource, aoData, fnCallback) {
            //        // 将客户名称加入参数数组
            //        //aoData.push( { "name": "customerName", "value": "asdas" } );//添加自己的额外参数
            //        $.ajax({
            //            "type": "POST",
            //            "url": "../handlers/Customer.ashx",
            //            "dataType": "json",
            //            "data": { Action: 'GetContractListByCompany', UserInfo: JSON.stringify(_userinfo), p: JSON.stringify(aoData) }, // 以json格式传递
            //            "success": function (resp) {
            //                //alert(JSON.stringify(resp));
            //                fnCallback(resp.data);
            //            }
            //        });
            //    }
            //});



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

            //添加按钮
            $('#toolbtn_add').click(function () {
                $('#customerCollapse').collapse('toggle');
                //资金项目按钮事件
                $('#nocdec-addon').click(function () {
                    $("#mark").val("rmb");
                    loadnode();
                });
                //资金项目按钮事件
                //$('#nocden-addon').click(function () {
                //    $("#mark").val("note");
                //    loadnode();
                //});

                //下拉列表初始化
                $('.selectpicker').selectpicker();



                function loadnode() {
                    $("#myitemModal").modal();
                    var tLength = $("#nodetable tr").length;
                    //如果加载过数据则直接显示Modal
                    if (tLength > 1) {
                        return;
                    }
                    $('#nodetable').dataTable({
                        "sPaginationType": "full_numbers",
                        "processing": true,//显示进度条
                        "serverSide": true,//发送服务器请求
                        "ajax": {
                            "url": "../handlers/CashItem.ashx",
                            "type": "POST",
                            "data": { Action: 'GetNcodeList' }
                        },
                        "columns": [{ "data": "ncode" }, { "data": "nname" }, { "data": null, defaultContent: "<button class='btn btn-default  btn-xs'>选中该条</button>" }],//"bVisible": false  style="display:none,
                        "columnDefs": [{
                            "targets": -1,
                            "data": null,
                            "defaultContent": "<button>Click!</button>"
                        }],
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
                                "url": "../handlers/CashItem.ashx",
                                "dataType": "json",
                                "data": { p: JSON.stringify(aoData), Action: 'GetNcodeList' }, // 以json格式传递
                                "success": function (resp) {
                                    //alert(JSON.stringify(resp));
                                    fnCallback(resp.data);
                                }
                            });
                        }
                    });

                    //NCODE表格内按钮点击事件
                    $('#nodetable tbody').on('click', 'button', function () {
                        var data = $(this).parents('tr').find('td');
                        //table.row()
                        if ($("#mark").val() == "rmb") {
                            $("#nocdec").val(data.eq(0).html() + ":" + data.eq(1).html());
                            $("#nocdec").attr("code", data.eq(0).html());
                        } else {
                            $("#nocden").val(data.eq(0).html() + ":" + data.eq(1).html());
                            $("#nocden").attr("code", data.eq(0).html());
                        }
                        $("#myitemModal").modal('hide');
                    });
                }
                //保存按钮
                $("#savbtn").click(function () {
                    //验证表单
                    var errormsg = "";
                    if ($("#datepicker1").val() == "") {
                        errormsg += "日期必须写!<br/>";
                    }

                    //验证现汇与票据的和与合同分配的金额是否相等  未完
                    if (isNaN($("#Rmb").val())) {
                        errormsg += "金额必须为数字!<br/>";
                    }

                    if ($("#nocdec").attr("code") == "" && $("#Rmb").val() != "") {
                        errormsg += "资金项目不能为空!<br/>";
                    }

                    if (errormsg != "") {
                        $('#savbtn').popover({ "title": "提示", "content": errormsg, "placement": 'top', html: true });
                        $('#savbtn').popover('show');
                        setTimeout(function () {
                            $('#savbtn').popover('destroy');
                        }, 5000);
                        return;
                    }

                    //封装formdata
                    var formdata = {};
                    formdata.Date = $("#datepicker1").val();
                    if ($("#Rmb").val() == "") {
                        formdata.Rmb = 0;
                    } else {
                        formdata.Rmb = $("#Rmb").val();
                    }
                    formdata.CashType = $("#rmbtype").val();;
                    formdata.NCode = $("#nocdec").attr("code");


                    //alert(JSON.stringify(formdata));
                    var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('customerCollapse'));
                    $.ajax({
                        type: 'POST',
                        url: '../Handlers/Expense.ashx',
                        data: { action: 'Commit', formdata: JSON.stringify(formdata) },
                        success: function suc(result) {
                            //alert(JSON.stringify(result));
                            //请求失败跳转到错误页
                            if (result.code != "0") {
                                redirecToErrorPage(result);
                                return;
                            }
                            if (result.data == null || result.data.length <= 0) {
                                $("#tablebody").empty();
                                $("#tablebody").append("无数据");
                                spinner1.stop();
                                return;
                            }
                            //操做成功 清空表单
                            $("#tablebody").empty();
                            $("#datepicker1").val("");
                            $("#Rmb").val("");
                            $("#Note").val("");

                            $("#nocdec").attr("code", "");
                            $("#nocden").attr("code", "");

                            $("#nocdec").val("");
                            $("#nocden").val("");

                            $("#customer").attr("code", "");
                            $("#customer").val("");
                            spinner1.stop();
                        },
                        dataType: 'JSON'
                    });
                    //****************************
                    //alert(JSON.stringify(paym));
                });
                $("#canbtn").click(function () {
                    $('#customerCollapse').collapse('toggle');
                });
            });

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
                    <button id="toolbtn_stateview" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="查看审批进度"><span class="glyphicon glyphicon-th-list" aria-hidden="true"></span></button>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div class="collapse" id="customerCollapse">
                <!--表单区域-->
                <div class="panel panel-primary">
                    <div class="panel-heading">新增一条记录</div>
                    <div class="panel-body">
                        <!--action很重要！！！！！！！！！！！！！！！！！！！！！！！！！1-->
                        <form>

                            <div class="form-group">
                                <label for="Rmb" class="control-label">金额</label>
                                <input type="number" class="form-control" id="Rmb" placeholder="金额" />
                            </div>

                            <div class="form-group">
                                <label for="rmbtype" class="control-label">类型</label>
                                <select id="rmbtype" class="selectpicker" data-width="100%" data-style="btn-default">
                                    <option>现金</option>
                                    <option>银行</option>
                                    <option>报账卡</option>
                                    <option>内部票</option>
                                </select>
                            </div>




                            <div class="form-group">
                                <label for="nocdec" class="control-label">现汇资金项目</label>
                                <div class="input-group">
                                    <input disabled="disabled" id="nocdec" type="text" class="form-control" placeholder="请选现汇资金项目" aria-describedby="nocdec-addon" />
                                    <span class="input-group-btn">
                                        <button id="nocdec-addon" class="btn btn-default" type="button">查找</button>
                                    </span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="datepicker1" class="control-label">日期</label>
                                <input id="datepicker1" type="date" class="form-control" placeholder="请选择日期">
                            </div>


                        </form>
                    </div>
                    <div class="panel-footer">
                        <button id="savbtn" type="button" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                        <button id="canbtn" type="button" class="btn btn-default">&nbsp;&nbsp;&nbsp;取&nbsp;消&nbsp;&nbsp;&nbsp;</button>
                    </div>
                </div>
            </div>

            <table id="dvtable" class="display" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>公司</th>
                        <th>摘要</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>状态</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>公司</th>
                        <th>金额</th>
                        <th>日期</th>
                        <th>状态</th>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <!--资金项目弹出层-->
    <div class="modal fade" id="myitemModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">选择客户</h4>
                </div>
                <div class="modal-body">
                    <div class="panel panel-info">
                        <div class="panel-body">
                            <input type="text" id="mark" />
                            <table id="nodetable" class="display compact" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th>编码</th>
                                        <th>项目</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="customerEnter" type="button" data-toggle="popover" class="btn btn-primary btn-lg">选中</button>
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
