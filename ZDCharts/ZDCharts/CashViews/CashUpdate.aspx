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
                    "columns": [
                                { "data": "ID" },
                                { "data": "CNAME", "sWidth": "300px" },
                                { "data": "ExchangeDate" },
                                { "data": "ContractTotal", 'sClass': "text-right" },
                                { "data": "Cash", 'sClass': "text-right" },
                                { "data": "Cash1", 'sClass': "text-right" },
                                { "data": "Note", 'sClass': "text-right" },
                                { "data": "Note1", 'sClass': "text-right" },
                                { "data": "MinusNote", 'sClass': "text-right" },
                                { "data": "MinusNote1", 'sClass': "text-right" },
                                { "data": "NCodeCName" },
                                { "data": "Total" },
                                { "data": "ApprovalStatusName" },
                                { "data": null, defaultContent: (state == 1000 ? "<button class='btn btn-default btn-block btn-sm' mark='1'>确定</button>" : ""), "orderable": false },
                                { "data": null, defaultContent: (state != 10000 ? "<button class='btn btn-default btn-block btn-sm' mark='3'>取消</button>" : ""), "orderable": false },
                                { "data": null, defaultContent: "<button class='btn btn-default btn-block btn-sm' mark='2'>查询</button>", "orderable": false },
                                { "data": null, defaultContent: "<button class='btn btn-default btn-block btn-sm' mark='4'>修改</button>", "orderable": false },
                                { "data": "Hdw" }
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
                         "sSearch": "按客户查找"
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
            //alert(1);
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
            function loadnode() {
                $("#myitemModal1").modal();
                var tLength = $("#nodetable1 tr").length;
                //如果加载过数据则直接显示Modal
                if (tLength > 1) {
                    return;
                }
                $('#nodetable1').dataTable({
                    "sPaginationType": "full_numbers",
                    "processing": true,//显示进度条
                    "serverSide": true,//发送服务器请求
                    "columns": [{ "data": "ncode" }, { "data": "nname" }, { "data": null, defaultContent: "<button class='btn btn-block btn-default'>选中</button>" }],//"bVisible": false  style="display:none,
                    "columnDefs": [{
                        "targets": -1,
                        "data": null,
                        "defaultContent": "<button>Click!</button>"
                    }],
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
                //NCODE按钮点击事件
                $('#nodetable1 tbody').on('click', 'button', function () {
                    var data = $(this).parents('tr').find('td');
                    $("#nocdec").val(data.eq(1).html());
                    $("#nocdec").attr("code", data.eq(0).html());
                    $("#myitemModal1").modal('hide');
                });
            }
            //表格内按钮点击事件 生成凭证按钮
            $('#dvtable tbody').on('click', "button[mark='1']", function () {
                var data = $(this).parents('tr').find('td');
                //alert(111);
                $("#myitemModal").modal('show');

                //获取资金池余额
                $.ajax({
                    "type": "POST",
                    "url": "../handlers/Finance.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetBalanceBy1221', companyid: data.eq(17).html() }, // 以json格式传递
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

                $("#rmb").val(data.eq(4).html());
                $("#note").val(data.eq(6).html());
                $("#mnote").val(data.eq(8).html());
                $("#mark").val(data.eq(0).html());
                $("#total").val(data.eq(11).html());

                $("#rmb").unbind();
                $("#note").unbind();
                $("#mnote").unbind();
                $("#rmb").on("input", function (e) {
                    //$("#note").val(Number($("#total").val()) - Number($("#rmb").val()));
                    $("#ye").val(Number($("#total").val()) - Number($("#rmb").val()) - Number($("#note").val()) + Number($("#mnote").val()));
                });
                $("#note").on("input", function (e) {
                    //$("#rmb").val(Number($("#total").val()) - Number($("#note").val()));
                    $("#ye").val(Number($("#total").val()) - Number($("#rmb").val()) - Number($("#note").val()) + Number($("#mnote").val()));
                });
                $("#mnote").on("input", function (e) {
                    //$("#rmb").val(Number($("#total").val()) - Number($("#note").val()));
                    $("#ye").val(Number($("#total").val()) - Number($("#rmb").val()) - Number($("#note").val()) + Number($("#mnote").val()));
                });
            });
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
            //表格内按钮点击事件 取消按钮
            $('#dvtable tbody').on('click', "button[mark='3']", function () {
                var data = $(this).parents('tr').find('td');
                $("#tag").val(data.eq(0).html());
                $("#cancelModal").modal('show');
            });
            //单据取消按钮事件
            $("#cancelBtn").click(function myfunction() {
                var spinner11 = new Spinner(getSpinOpts()).spin(document.getElementById('cancelModal'));
                $.ajax({
                    type: 'POST',
                    url: '../Handlers/WFFlow1.ashx',
                    data: { action: 'CancelDoc', id: $("#tag").val() },
                    success: function suc(result) {
                        location.reload();
                    },
                    dataType: 'JSON'
                });
            });
            //表格内按钮点击事件 修改记录
            $('#dvtable tbody').on('click', "button[mark='4']", function () {
                $("#updateModal").modal();
                $("#panelheadtext").text("修改记录");
                $('#customerCollapse').collapse('toggle');
                $('#tablediv').toggle();
                var data = $(this).parents('tr').find('td');
                $("#docid").val(data.eq(0).html());
                $("#canbtn").unbind();
                $("#canbtn").click(function myfunction() {
                    $('#customerCollapse').collapse('toggle');
                    $('#tablediv').toggle();
                });

                $("#customer-addon").attr("disabled", true);
                $('#nocdec-addon').unbind();
                $('#nocdec-addon').click(function () {
                    $("#mark").val("rmb");
                    loadnode();
                });
                $.ajax({
                    "type": "POST",
                    "url": "../handlers/WFFlow1.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetModelByID', id: $("#docid").val() }, // 以json格式传递
                    "success": function (resp) {
                        //alert(JSON.stringify(resp.data0));
                        $("#datepicker1").val(resp.data.ExchangeDate.toString().substr(0, 10));
                        $("#Rmb").val(resp.data.Cash);
                        $("#Note").val(resp.data.Note);
                        $("#MNote").val(resp.data.MinusNote);
                        $("#nocdec").attr("code", resp.data.NCodeC);
                        $("#nocdec").val(resp.data.NCodeCName);
                        $("#MNote").val(resp.data.MinusNote);
                        $("#customer").val(resp.data.CNAME);
                        $.ajax({
                            type: 'POST',
                            url: '../Handlers/Customer.ashx',
                            data: { action: 'GetContractByCustomer1', CustomerID: resp.data.Ccode, CompanyID: data.eq(17).html() },
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
                                $("#tablebody").empty();
                                //绑定数据
                                for (var i = 0; i < result.data.length; i++) {
                                    var shtml = "";
                                    try {
                                        shtml = shtml.concat("<tr>");
                                        shtml = shtml.concat("<td>" + result.data[i].HCODE + "</td>");
                                        shtml = shtml.concat("<td style='text-align:right'>" + result.data[i].Total + "</td>");
                                        shtml = shtml.concat("<td style='text-align:right'>" + result.data[i].NonRmb + "</td>");
                                        shtml = shtml.concat("<td style='text-align:center'><input type='text' class='form-control text-right' id='currmb' placeholder='" + result.data[i].HCODE + "本次付款金额'  changemark='a'></td>");
                                        shtml = shtml.concat("<td style='text-align:center'><select class='selectpicker form-control'>");
                                        //销售合同号下拉列表数据绑定
                                        var xslist = eval("(" + result.data[i].XSHCODE + ")");
                                        for (var j = 0; j < xslist.length; j++) {
                                            shtml = shtml.concat("<option>" + xslist[j] + "</option>");
                                        };
                                        shtml = shtml.concat("</select></td>");
                                        shtml = shtml.concat("</tr>");
                                        $("#tablebody").append(shtml);
                                        $("select.selectpicker").each(function () {
                                        });
                                    } catch (e) {
                                        alert(e.message)
                                    };
                                }

                                //计算余额
                                $("input[changemark='a']").unbind();
                                $("input[changemark='a']").on("input", function (e) {
                                    var total = 0;
                                    $("#tablebody tr").each(function (i, item) {
                                        var currmb = $.trim($(item).find("td").find("input").val());
                                        if (!(currmb == "" || isNaN(currmb))) {
                                            total += Number(currmb);
                                        }
                                    });
                                    $("#curbalrmb").val(Number($("#Rmb").val()) + Number($("#Note").val()) - Number($("#MNote").val()) - total);
                                });
                                for (var i = 0; i < resp.data0.length; i++) {
                                    $("#tablebody tr").each(function (j, item) {
                                        if ($(item).find("td").eq(0).html() == resp.data0[i].HCode) {
                                            $(item).find("td").find("input").val(resp.data0[i].CurRmb);
                                        }
                                    });
                                }
                                if (resp.data.ApprovalStatus != "0") {
                                    //alert(resp.data.ApprovalStatus);
                                    $("#panelheadtext").text("修改记录（已经在审批中的单据只能修改资金项目）");
                                    $("#Rmb").attr("disabled", true);
                                    $("#Note").attr("disabled", true);
                                    $("#tablebody tr").each(function (i, item) {
                                        $(item).find("td").find("input").attr("disabled", true);
                                        if ($(item).find("td").find("input").val() == "") {
                                            $(item).remove();
                                        }
                                    });
                                }
                                spinner1.stop();
                            },
                            dataType: 'JSON'
                        });

                    }
                });

                $("#savbtn").unbind();
                $("#savbtn").click(function () {
                    //验证表单
                    var errormsg = "";
                    if ($("#datepicker1").val() == "") {
                        errormsg += "日期必须写!<br/>";
                    }
                    if ($("#customer").attr("code") == "") {
                        errormsg += "客户必须填写!<br/>";
                    }
                    //验证现汇与票据的和与合同分配的金额是否相等  未完
                    var _total = 0;
                    $("#tablebody tr").each(function (i, item) {
                        var _rmb = $.trim($(item).find("td").find("input").val());
                        if (!(_rmb == "" || isNaN(_rmb))) {
                            _total += Number(_rmb);
                        }
                    });
                    if (isNaN($("#Rmb").val()) || isNaN($("#Note").val())) {
                        errormsg += "金额必须为数字!<br/>";
                    }
                    var _total1 = Number($("#Rmb").val()) + Number($("#Note").val()) - Number($("#MNote").val());
                    if (_total != _total1) {
                        errormsg += "总金额与合同分配金额不相等!<br/>";
                    }
                    if ($("#nocdec").attr("code") == "" && $("#Rmb").val() != "") {
                        errormsg += "现汇资金项目不能为空!<br/>";
                    }
                    if ($("#nocden").attr("code") == "" && $("#Note").val() != "") {
                        errormsg += "票据资金项目不能为空!<br/>";
                    }

                    if (errormsg != "") {
                        $('#savbtn').popover({ "title": "提示", "content": errormsg, "placement": 'top', html: true });
                        $('#savbtn').popover('show');
                        setTimeout(function () {
                            $('#savbtn').popover('destroy');
                        }, 5000);
                        return;
                    }

                    //封装payinfo
                    var paym = {};
                    paym.PayDate = $("#datepicker1").val();
                    if ($("#Rmb").val() == "") {
                        paym.Rmb = 0;
                    } else {
                        paym.Rmb = $("#Rmb").val();
                    }
                    if ($("#Note").val() == "") {
                        paym.Note = 0;
                    } else {
                        paym.Note = $("#Note").val();
                    }
                    if ($("#MNote").val() == "") {
                        paym.MNote = 0;
                    } else {
                        paym.MNote = $("#MNote").val();
                    }
                    paym.NCodeC = $("#nocdec").attr("code");
                    var paymList = [];
                    paym.List = paymList;
                    $("#tablebody tr").each(function (i, item) {
                        var currmb = $.trim($(item).find("td").find("input").val());
                        if (!(currmb == "" || isNaN(currmb))) {
                            var paymitem = {};
                            paymitem.HCODE = $(item).find("td").eq(0).html();
                            paymitem.CurRmb = currmb;
                            paymitem.XSHCODE = $.trim($(item).find("td").find("select").val());;
                            paymList.push(paymitem);
                        }
                    });
                    var spinner22 = new Spinner(getSpinOpts()).spin(document.getElementById('customerCollapse'));
                    $.ajax({
                        type: 'POST',
                        url: '../Handlers/WFFlow1.ashx',
                        data: { action: 'DoUpdateDoc', PayInfo: JSON.stringify(paym), id: $("#docid").val() },
                        success: function suc(result) {

                            location.reload();
                        },
                        dataType: 'JSON'
                    });
                    //****************************
                    //alert(JSON.stringify(paym));
                });
            });
            //审批状态下拉菜单事件
            $("#dropdownMenu li a").click(function () {
                $("#dropdownMenuTitleBtn").text($(this).text());

                $('#dvtable').dataTable().fnDestroy()
                loadData($(this).attr("sid"));
            });
            //$("#commitBtn").unbind()
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
                postdata.MNote = Number($("#mnote").val());
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
                <%--<div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增一条记录"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                </div>--%>
                <%--<div class="btn-group" role="group">
                    <button id="toolbtn_update" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="修改选中记录"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></button>
                    <button id="toolbtn_del" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="删除选中记录"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button>
                </div>--%>
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
                        <li><a href="javascript:void(0)" sid="100000">取消&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
                        <li><a href="javascript:void(0)" sid="-1">审批未通过</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <div class="collapse" id="customerCollapse">



                <div class="panel panel-primary">
                    <div class="panel-heading" id="panelheadtext">新增一条记录</div>
                    <div class="panel-body">
                        <input id="docid" type="hidden" />
                        <!--action很重要！！！！！！！！！！！！！！！！！！！！！！！！！1-->
                        <form>
                            <div class="form-group">
                                <label for="customer" class="control-label">客户</label>
                                <div class="input-group">
                                    <input disabled id="customer" type="text" class="form-control" placeholder="请选择客户" aria-describedby="customer-addon">
                                    <span class="input-group-btn">
                                        <button id="customer-addon" class="btn btn-default" type="button">查找</button></span>
                                </div>
                            </div>
                            <table width="100%">
                                <tr>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="Rmb" class="control-label">现汇</label>
                                            <input type="number" class="form-control" id="Rmb" placeholder="现汇" changemark="a">
                                        </div>
                                    </td>
                                    <td width="4%"></td>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="Note" class="control-label">票据</label>
                                            <input type="number" class="form-control" id="Note" placeholder="票据" changemark="a">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="mnote" class="control-label">退票据</label>
                                            <input type="number" class="form-control" id="MNote" placeholder="退票据" changemark="a">
                                        </div>
                                    </td>
                                    <td width="4%"></td>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="curbalrmb" class="control-label">本次余额</label>
                                            <input disabled="disabled" type="number" class="form-control" id="curbalrmb" placeholder="余额">
                                        </div>
                                    </td>
                                </tr>
                                <div class="form-group">
                                    <label for="nocdec" class="control-label">资金项目</label>
                                    <div class="input-group">
                                        <input disabled="disabled" id="nocdec" type="text" class="form-control" placeholder="请选资金项目" aria-describedby="nocdec-addon" />
                                        <span class="input-group-btn">
                                            <button id="nocdec-addon" class="btn btn-default" type="button">查找</button>
                                        </span>
                                    </div>
                                </div>

                                <!--<td style="width: 10%"></td>
                            <td style="width: 45%">
                                <div class="form-group">
                                    <label for="nocden" class="control-label">票据资金项目</label>
                                    <div class="input-group">
                                        <input disabled="disabled" id="nocden" type="text" class="form-control" placeholder="请选择票据资金项目" aria-describedby="nocden-addon" />
                                        <span class="input-group-btn">
                                            <button id="nocden-addon" class="btn btn-default" type="button">查找</button>
                                        </span>
                                    </div>
                                </div>
                            </td>-->
                                <div class="form-group">
                                    <label class="control-label">日期</label>
                                    <input id="datepicker1" disabled="disabled" type="date" class="form-control" placeholder="请选择日期" />
                                </div>

                                <div class="panel panel-info">
                                    <!-- Default panel contents -->
                                    <div class="panel-heading">合同信息</div>
                                    <!-- Table -->
                                    <table id="datalist" class="table  table-hover  table-bordered">
                                        <thead>
                                            <tr>
                                                <th style='text-align: center'>合同号</th>
                                                <th style='text-align: center'>金额</th>
                                                <th style='text-align: center'>未付款</th>
                                                <th style='text-align: center'>本次</th>
                                                <th style='text-align: center'>销售合同</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tablebody">
                                            <!--行模板-->
                                            <!--<tr>
                                            <td>ZD001</td>
                                            <td style='text-align:right'>150,000</td>
                                            <td style='text-align:right'>50,000</td>
                                            <td style='text-align:center'>
                                                <input type="text" class="form-control text-right" id="currmb" placeholder="ZD001付款金额">
                                            </td>
                                            <td style='text-align:center'>
                                                <select class='selectpicker form-control'>
                                                    <option>2012</option>
                                                    <option>2013</option>
                                                </select>
                                            </td>
                                        </tr>-->
                                        </tbody>
                                    </table>
                                </div>
                        </form>
                    </div>
                    <div class="panel-footer">
                        <button id="savbtn" type="button" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                        <button id="canbtn" type="button" class="btn btn-default">&nbsp;&nbsp;&nbsp;取&nbsp;消&nbsp;&nbsp;&nbsp;</button>
                    </div>
                </div>


            </div>
            <div id="tablediv">
                <table id="dvtable" class="display compact cell-border" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">编号</th>
                            <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">客户</th>
                            <th rowspan="2" class="myTopBorder myLeftBorder" style="text-align: center;">日期</th>
                            <th rowspan="2" class="myTopBorder myLeftBorder myRigthBorder" style="text-align: center;">合同付款金额</th>
                            <th colspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">现汇</th>
                            <th colspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">票据</th>
                            <th colspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">红冲</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">资金项目</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">合计</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">审批状态</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">生成凭证</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">取消</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">审批进度</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">修改</th>
                            <th rowspan="2" class="myTopBorder myRigthBorder" style="text-align: center;">公司</th>
                        </tr>
                        <tr>
                            <th class="myRigthBorder">预计</th>
                            <th class="myRigthBorder">实出</th>
                            <th class="myRigthBorder">预计</th>
                            <th class="myRigthBorder">实出</th>
                            <th class="myRigthBorder">预计</th>
                            <th class="myRigthBorder">实出</th>
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
                            <th>合计</th>
                            <th>审批状态</th>
                            <th>生成凭证</th>
                            <th>取消</th>
                            <th>审批进度</th>
                            <th>修改</th>
                            <th>公司</th>
                        </tr>

                    </tfoot>
                </table>
            </div>
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
                        <div class="panel-heading">资金池余额</div>
                        <div class="panel-body">
                            <table style="width: 100%" class="table">
                                <thead>
                                    <tr>
                                        <th style="width: 25%; text-align: left">类型\金额</th>
                                        <th style="width: 25%; text-align: center">合计</th>
                                        <th style="width: 25%; text-align: center">现汇</th>
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
                    <div class="panel panel-info">
                        <%--<div class="panel-heading">新增一条记录</div>--%>
                        <div class="panel-body">
                            <input type="hidden" id="mark" />
                            <table width="100%">
                                <tr>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="total" class="control-label">本次合计</label>
                                            <input disabled="disabled" id="total" type="number" class="form-control glyphicon-align-right" placeholder="本次合计" />
                                        </div>
                                    </td>
                                    <td width="2%"></td>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="ye" class="control-label">本次余额</label>
                                            <input disabled="disabled" id="ye" type="number" class="form-control glyphicon-align-right" placeholder="本次余额" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="rmb" class="control-label">现汇实际支出</label>
                                            <input id="rmb" type="number" class="form-control glyphicon-align-right" placeholder="请现汇金额" />
                                        </div>
                                    </td>
                                    <td width="2%"></td>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="note" class="control-label">票据实际支出</label>
                                            <input id="note" type="number" class="form-control" placeholder="请票据金额" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="48%">
                                        <div class="form-group">
                                            <label for="mnote" class="control-label">实际退票</label>
                                            <input id="mnote" type="number" class="form-control" placeholder="实际退票" />
                                        </div>
                                    </td>
                                    <td width="2%"></td>
                                    <td width="48%"></td>
                                </tr>
                            </table>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button id="commitBtn" type="button" data-toggle="popover" class="btn btn-primary btn-lg">生成凭证</button>
                        <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                    </div>
                </div>
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
    <%--单据取消弹出层--%>
    <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">单据取消确认</h4>
                </div>
                <div class="modal-body">
                    <input id="tag" type="hidden" />
                    <button id="cancelBtn" type="button" data-toggle="popover" class="btn btn-primary btn-lg btn-block">确定</button>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default btn-lg" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
    <!--资金项目弹出层-->
    <div class="modal fade" id="myitemModal1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel1">选择资金项目</h4>
                </div>
                <div class="modal-body">
                    <div class="panel-body">
                        <input type="hidden" id="mark1" />
                        <table id="nodetable1" class="display compact" cellspacing="0" width="100%">
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
        </div>
    </div>
</body>
</html>
