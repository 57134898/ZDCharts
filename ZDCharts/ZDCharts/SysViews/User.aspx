<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="ZDCharts.SysViews.User" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
    <title>修改密码</title>
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <script src="../Scripts/jquery-2.1.3.min.js"></script>
    <script src="../Scripts/bootstrap.min.js"></script>
    <script src="/Scripts/DataTables/jquery.dataTables.min.js"></script>
    <link href="/Content/DataTables/css/jquery.dataTables.min.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            //汉化
            var language = {
                "sLengthMenu": "每页显示 _MENU_ 条记录",
                "sZeroRecords": "抱歉， 没有找到",
                "sInfo": "从 _START_ 到 _END_ /共 _TOTAL_ 条数据",
                "sInfoEmpty": "没有数据",
                "sInfoFiltered": "(从 _MAX_ 条数据中检索)",
                "oPaginate": { "sFirst": "首页", "sPrevious": "上一页", "sNext": "下一页", "sLast": "末页" },
                "sZeroRecords": "没有检索到数据",
                "sProcessing": "<img src='../Images/loading.gif'>加载中...",
                "sSearch": "按客户查找"
            };
            var columns = [
                            { "data": "EmpID" },
                            { "data": "EmpName" },//, "sWidth": "300px"
                            { "data": "Psw" },
                            { "data": "DeptID" },
                            { "data": "DeptName" },
                            { "data": "RoleID" },
                            { "data": "RoleName" },
                            { "data": "CompanyID" },
                            { "data": "CompanyName" },
                            { "data": "IsEnabled" },
                            { "data": null, defaultContent: "<button class='btn btn-default btn-block btn-sm' mark='1'>更新</button>" },
                            { "data": null, defaultContent: "<button class='btn btn-default btn-block btn-sm' mark='2'>停用</button>" }
            ];
            //请求处理函数
            var func = function retrieveData(sSource, aoData, fnCallback) {
                // 将客户名称加入参数数组
                //aoData.push( { "name": "customerName", "value": "asdas" } );//添加自己的额外参数
                $.ajax({
                    "type": "POST", "dataType": "json", "success": function (resp) { fnCallback(resp.data); },
                    "url": "/handlers/sys.ashx",
                    "data": { Action: 'GetUserList', p: JSON.stringify(aoData) } // 以json格式传递
                });
            }
            $('#dvtable').dataTable({
                "sPaginationType": "full_numbers",
                "processing": true,//显示进度条
                "scrollX": true,//水平滚动条
                //"bAutoWidth": false,//自动列宽
                "serverSide": true,//发送服务器请求
                "columns": columns, "language": language, "fnServerData": func
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
    <div class="panel">
        <div class="panel-heading">
            <!--  工具栏-->
            <div class="btn-toolbar" role="toolbar">
                <div class="btn-group" role="group">
                    <button id="toolbtn_refresh" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="刷新"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="toolbtn_add" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="新增"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
                </div>
                <div class="btn-group" role="group">
                    <button id="dropdownMenuTitleBtn" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                        可&nbsp;&nbsp;用
                       <span class="caret"></span>
                    </button>
                    <ul id="dropdownMenu" class="dropdown-menu" role="menu">
                        <li><a href="javascript:void(0)" sid="0">可&nbsp;&nbsp;用</a></li>
                        <li><a href="javascript:void(0)" sid="100">不可用</a></li>
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
                <table id="dvtable" class="display compact" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>编号</th>
                            <th>用户名</th>
                            <th>密码</th>
                            <th>编号</th>
                            <th>部门</th>
                            <th>编号</th>
                            <th>角色</th>
                            <th>编号</th>
                            <th>公司</th>
                            <th>状态</th>
                            <th>修改</th>
                            <th>停用</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
