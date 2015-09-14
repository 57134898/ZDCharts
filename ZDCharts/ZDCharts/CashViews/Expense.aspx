<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Expense.aspx.cs" Inherits="ZDCharts.CashViews.Expense" %>

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
            //默认加载 审批完成但未生成凭证的数据 
            loadData(0);
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
            $('#toolbtn_add').click(function () {
                $('#customerCollapse').collapse('toggle');
                // alert(1);
                $('#tablediv').toggle();
                //设置日期默认值为当天
                var mydate = new Date();
                var today = mydate.getFullYear().toString()
                    + "-"
                    + ((mydate.getMonth() + 1).toString().length == 1 ? ("0" + (mydate.getMonth() + 1).toString()) : (mydate.getMonth() + 1).toString())
                    + "-"
                    + ((mydate.getDate() + 1).toString().length == 1 ? ("0" + (mydate.getDate() + 1).toString()) : (mydate.getDate() + 1).toString());
                $("#datepicker1").val(today);

                //获取资金池余额
                $.ajax({
                    "type": "POST",
                    "url": "../handlers/Finance.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetBalanceBy1221', companyid: "company" }, // 以json格式传递
                    "success": function (resp) {
                        var bal = eval("(" + resp.data + ")");
                        $("#balrmb").html(bal.rmb);
                        $("#balnote").html(bal.note);
                        $("#baltotal").html(bal.total);

                        $("#balrmb1").html(bal.rmb1);
                        $("#balnote1").html(bal.note1);
                        $("#baltotal1").html(bal.total1);

                        $("#balrmb2").html(bal.rmb2);
                        $("#balnote2").html(bal.note2);
                        $("#baltotal2").html(bal.total2);

                        $("#balrmb3").html(bal.rmb3);
                        $("#balnote3").html(bal.note3);
                        $("#baltotal3").html(bal.total3);

                        $("#balrmb4").html(bal.rmb4);
                        $("#balnote4").html(bal.note4);
                        $("#baltotal4").html(bal.total4);
                    }
                });

                //资金项目按钮事件
                $('#nocdec-addon').click(function () {
                    $("#mark").val("rmb");
                    loadnode();
                });
                //资金项目按钮事件
                $('#nocden-addon').click(function () {
                    $("#mark").val("note");
                    loadnode();
                });

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
                        //"ajax": {
                        //    "url": "../handlers/CashItem.ashx",
                        //    "type": "POST",
                        //    "data": { Action: 'GetNcodeLista' }
                        //},
                        "columns": [{ "data": "ncode" }, { "data": "nname" }, { "data": null, defaultContent: "<button class='btn btn-block btn-default'>选中</button>" }],//"bVisible": false  style="display:none,
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
                                "data": { p: JSON.stringify(aoData), Action: 'GetNcodeList1' }, // 以json格式传递
                                "success": function (resp) {
                                    //alert(JSON.stringify(resp));
                                    fnCallback(resp.data);
                                }
                            });
                        }
                    });

                    //NCODE按钮点击事件
                    $('#nodetable tbody').on('click', 'button', function () {
                        var data = $(this).parents('tr').find('td');
                        //table.row()
                        // if ($("#mark").val() == "rmb") {
                        $("#nocdec").val(data.eq(0).html() + "-" + data.eq(1).html());
                        $("#nocdec").attr("code", data.eq(0).html());
                        //} else {
                        //$("#nocden").val(data.eq(0).html() + ":" + data.eq(1).html());
                        //$("#nocden").attr("code", data.eq(0).html());
                        //}
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

                    if ($("#Rmb").val() == "") {
                        errormsg += "金额不能为空!<br/>";
                    }
                    //if (isNaN($("#Note").val())) {
                    //    errormsg += "金额必须为数字!<br/>";
                    //}

                    if ($("#Note").val() == "") {
                        errormsg += "金额不能为空!<br/>";
                    }

                    //alert($("#nocdec").attr("code"));
                    if ($("#nocdec").attr("code") == undefined || $("#nocdec").attr("code") == "") {
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
                    formdata.RmbType = $("#rmbtype").val();
                    formdata.Rmb = Number($("#Rmb").val());
                    //formdata.Note = Number($("#Note").val());

                    var list = [];
                    $("#addrowbody tr").each(function (i, item) {
                        //alert($(subitem).html());
                        var listitem = {};
                        listitem.Todo = $(item).find("td").eq(0).html();
                        listitem.NCode = $(item).find("td").eq(1).html();
                        listitem.Rmb = $(item).find("td").eq(2).html();
                        list.push(listitem);
                    })
                    formdata.RList = list;

                    //formdata.CashType = $("#rmbtype").val();
                    //formdata.NCodeC = $("#nocdec").attr("code");
                    //formdata.NCodeN = $("#nocdec").attr("code");
                    formdata.Todo = $("#Todo").val();
                    //alert(JSON.stringify(formdata));
                    //return;
                    var spinner1 = new Spinner(getSpinOpts()).spin(document.getElementById('customerCollapse'));
                    $.ajax({
                        type: 'POST',
                        url: '../Handlers/Expense.ashx',
                        data: { action: 'Commit', formdata: JSON.stringify(formdata) },
                        success: function suc(result) {
                            //alert(JSON.stringify(result));
                            //请求失败跳转到错误页
                            if (result.code != "0") {
                                alert(JSON.stringify(result));
                                //redirecToErrorPage(result);
                                return;
                            }
                            if (result.data == null || result.data.length <= 0) {
                                //$("#tablebody").empty();
                                //$("#tablebody").append("无数据");
                                spinner1.stop();
                                return;
                            }
                            //操做成功 清空表单
                            // $("#tablebody").empty();
                            //$("#datepicker1").val("");
                            $("#Rmb").val("");
                            $("#Note").val("");
                            $("#Todo").val("");
                            $("#nocdec").attr("code", "");
                            $("#nocdec").val("");
                            $("#addrowbody").empty();
                            $("#rmbrow").val("");
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
            //审批状态下拉菜单事件
            $("#dropdownMenu li a").click(function () {
                $("#dropdownMenuTitleBtn").text($(this).text());

                $('#dvtable').dataTable().fnDestroy()
                loadData($(this).attr("sid"));
            });
            //工具栏按钮tooltip设置
            $('[data-toggle="tooltip"]').tooltip();

            $("#addrowbtn").click(function () {
                var sHtml = "<tr>";
                sHtml += "<td>" + $("#todorow").val() + "</td>";
                sHtml += "<td>" + $("#nocdec").val() + "</td>";
                sHtml += "<td style='text-align: right'>" + $("#rmbrow").val() + "</td>";
                sHtml += "<td><button name='delrow' type='button' class='btn btn-block  btn-default'>删除行</button></td></tr>";
                $("#addrowbody").append(sHtml);
                $("#todorow").val("");
                $("#rmbrow").val("");
                $("#Rmb").val(dosum());
                $("[name='delrow']").click(function () {
                    $(this).parent().parent().remove();
                    $("#Rmb").val(dosum());
                });
            });
            function dosum() {
                var _total = 0;
                $("#addrowbody tr").each(function (i, item) {
                    var _rmb = $.trim($(item).find("td").eq(2).html());
                    if (!(_rmb == "" || isNaN(_rmb))) {
                        _total += Number(_rmb);
                    }
                });
                return _total;
            }
        });
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-heading">
            <!--工具栏-->
            <div class="btn-toolbar" role="toolbar">
                <!--工具栏分组-->
                <!--                
                    <div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增一条记录"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_update" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="修改选中记录"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></button>
                    <button id="toolbtn_del" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="删除选中记录"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_refresh" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="刷新"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
                </div>-->
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
            <div class="collapse" id="customerCollapse">
                <!--表单区域-->
                <div class="panel panel-primary">
                    <div class="panel-heading">新增一条记录</div>
                    <div class="panel-body">
                        <!--action很重要！！！！！！！！！！！！！！！！！！！！！！！！！1-->
                        <form>
                            <table style="width: 100%">
                                <tr>
                                    <td style="width: 49%">
                                        <div class="form-group">
                                            <label for="Todo" class="control-label">摘要</label>
                                            <input type="text" class="form-control" id="Todo" placeholder="摘要" />
                                        </div>
                                    </td>
                                    <td style="width: 2%"></td>
                                    <td style="width: 49%">
                                        <div class="form-group">
                                            <label for="datepicker1" class="control-label">日期</label>
                                            <input id="datepicker1" disabled="disabled" type="date" class="form-control" placeholder="请选择日期" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 49%">
                                        <div class="form-group">
                                            <label for="Rmb" class="control-label">金额</label>
                                            <input disabled="disabled" type="number" class="form-control" id="Rmb" placeholder="金额" />
                                        </div>
                                    </td>
                                    <td style="width: 2%"></td>
                                    <td style="width: 49%">

                                        <div class="form-group">
                                            <label for="rmbtype" class="control-label">类型</label>
                                            <select id="rmbtype" class="selectpicker" data-width="100%" data-style="btn-default">
                                                <option>现金</option>
                                                <option>票据</option>
                                                <%--                                                <option>报账卡</option>
                                                <option>内部票</option>--%>
                                            </select>
                                        </div>
                                        <%--            <div class="form-group">
                                            <label for="Note" class="control-label">票据</label>
                                            <input type="number" class="form-control" id="Note" placeholder="票据" />
                                        </div>--%>
                                    </td>
                                </tr>
                            </table>
                            <div class="panel panel-info">
                                <!-- Default panel contents -->
                                <div class="panel-heading">明细</div>
                                <!-- Table -->
                                <table id="datalist" class="table  table-hover  table-bordered">
                                    <thead>
                                        <tr>
                                            <th style='text-align: center'>摘要</th>
                                            <th style='text-align: center'>资金项目</th>
                                            <th style='text-align: center'>金额</th>
                                            <th style='text-align: center'>删除行</th>
                                        </tr>
                                    </thead>
                                    <tbody id="addrowbody">
                                        <!--行模板-->
                                        <%--                                       <tr>
                                            <td>销售公司电费</td>
                                            <td>电费</td>
                                            <td style='text-align: right'>1100
                                            </td>
                                            <td>
                                                <button id="delrowbtn" type="button" class="btn btn-block  btn-default">删除行</button>
                                            </td>
                                        </tr>--%>
                                    </tbody>
                                </table>

                            </div>
                            <table id="addtab" style="width: 100%">
                                <thead>

                                    <tr>
                                        <th style="width: 25%">
                                            <div class="form-group">
                                                <label for="todorow" class="control-label">摘要</label>
                                                <input type="text" class="form-control" id="todorow" placeholder="摘要" />
                                            </div>
                                        </th>
                                        <th style="width: 1%"></th>
                                        <th style="width: 25%">
                                            <div class="form-group">
                                                <label for="nocdec" class="control-label">资金项目</label>
                                                <div class="input-group">
                                                    <input disabled="disabled" id="nocdec" type="text" class="form-control" placeholder="请选资金项目" aria-describedby="nocdec-addon" />
                                                    <span class="input-group-btn">
                                                        <button id="nocdec-addon" class="btn btn-default" type="button">查找</button>
                                                    </span>
                                                </div>
                                            </div>
                                        </th>
                                        <th style="width: 1%"></th>
                                        <th style="width: 25%">
                                            <div class="form-group">
                                                <label for="rmbrow" class="control-label">金额</label>
                                                <input type="number" class="form-control" id="rmbrow" placeholder="金额" />
                                            </div>
                                        </th>
                                        <th style="width: 1%"></th>
                                        <th style="width: 22%">
                                            <div class="form-group">
                                                <label class="control-label">&nbsp;</label>
                                                <button id="addrowbtn" type="button" class="btn btn-block  btn-default">&nbsp;添加明细&nbsp;</button>
                                            </div>
                                        </th>
                                    </tr>
                                </thead>
                            </table>
                        </form>

                    </div>


                    <div class="panel-footer">

                        <button id="savbtn" type="button" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                        <button id="canbtn" type="button" class="btn btn-default">&nbsp;&nbsp;&nbsp;取&nbsp;消&nbsp;&nbsp;&nbsp;</button>

                    </div>
                </div>
                <div class="panel panel-info">
                    <div class="panel-heading">资金池余额</div>
                    <div class="panel-body">
                        <table style="width: 100%" class="table">
                            <thead>
                                <tr>
                                    <th style="width: 25%; text-align: left">类型\金额</th>
                                    <th style="width: 25%; text-align: center">合计</th>
                                    <th style="width: 25%; text-align: center">现金</th>
                                    <th style="width: 25%; text-align: center">票据</th>
                                </tr>

                            </thead>
                            <tbody>
                                <tr>
                                    <td style="width: 25%">财务</td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="baltotal" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balrmb" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balnote" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 25%">已审批</td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="baltotal1" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balrmb1" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balnote1" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 25%">未审批</td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="baltotal2" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balrmb2" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balnote2" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 25%">已生成凭证</td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="baltotal3" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balrmb3" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balnote3" />
                                    </td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td style="width: 25%">总计</td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="baltotal4" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balrmb4" />
                                    </td>
                                    <td style="width: 25%; text-align: right">
                                        <div id="balnote4" />
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>

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
                        <th>审批查询</th>
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
                    <h4 class="modal-title" id="myModalLabel">选择资金项目</h4>
                </div>
                <div class="modal-body">
                    <%--     <div class="panel panel-info">--%>
                    <div class="panel-body">
                        <input type="hidden" id="mark" />
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
                    <%--</div>--%>
                </div>
                <%--                <div class="modal-footer">
                    <button id="customerEnter" type="button" data-toggle="popover" class="btn btn-primary btn-lg">选中</button>
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>--%>
            </div>
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
