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
            //表格内按钮点击事件 修改按钮
            $('#dvtable tbody').on('click', "button[mark='1']", function () {
                var data = $(this).parents('tr').find('td');
                $('#empCollapse').collapse('toggle');
                $('#tablediv').toggle();
                $("#tempid").val(data.eq(0).html());
                $("#action").val("U");
                $("#psw").val(data.eq(2).html());
                $("#empname").val(data.eq(1).html());
                $("#empid").val(data.eq(0).html());
                $("#empid").attr("disabled", true);
                $.ajax({
                    "type": "POST",
                    "url": "/handlers/sys.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetDeptAndRoleList' }, // 以json格式传递
                    "success": function (resp) {
                        //var bal = eval("(" + resp.data + ")");
                        //$("#balrmb").html(bal.rmb);
                        //alert(resp.data);
                        for (var i = 0; i < resp.data0.length; i++) {
                            var option = $("<option>").val(1).text(resp.data0[i].RoleID + "-" + resp.data0[i].RoleName);
                            if ((data.eq(5).html() + "-" + data.eq(6).html()) == option.text()) {
                                option.attr("selected", true);
                            }
                            $("#role").append(option);
                        }
                        for (var i = 0; i < resp.data.length; i++) {
                            var option = $("<option>").val(1).text(resp.data[i].DeptID + "-" + resp.data[i].DeptName);
                            if ((data.eq(3).html() + "-" + data.eq(4).html()) == option.text()) {
                                option.attr("selected", true);
                            }
                            $("#dept").append(option);
                        }
                    }
                });
            });
            //表格内按钮点击事件 停用按钮
            $('#dvtable tbody').on('click', "button[mark='2']", function () {
                $('#checkmodal').modal('show');
                var data = $(this).parents('tr').find('td');
                $("#tempuserid").val(data.eq(0).html());
            });

            $("#commit").click(function () {
                $.ajax({
                    "type": "POST",
                    "url": "/handlers/sys.ashx",
                    "dataType": "json",
                    "data": { Action: 'StopUser', userid: $("#tempuserid").val() }, // 以json格式传递
                    "success": function (resp) {
                        location.reload();
                    }
                });
            });


            //新增按钮
            $("#toolbtn_add").click(function () {
                $('#empCollapse').collapse('toggle');
                $('#tablediv').toggle();
                $("#psw").val("");
                $("#empname").val("");
                $("#empid").val("");
                $("#empid").attr("disabled", false);
                if ($("#dept").children().length > 0) {
                    return;
                }
                $.ajax({
                    "type": "POST",
                    "url": "/handlers/sys.ashx",
                    "dataType": "json",
                    "data": { Action: 'GetDeptAndRoleList' }, // 以json格式传递
                    "success": function (resp) {
                        //var bal = eval("(" + resp.data + ")");
                        //$("#balrmb").html(bal.rmb);
                        //alert(resp.data);
                        for (var i = 0; i < resp.data0.length; i++) {
                            var option = $("<option>").val(1).text(resp.data0[i].RoleID + "-" + resp.data0[i].RoleName);
                            $("#role").append(option);
                        }
                        for (var i = 0; i < resp.data.length; i++) {
                            var option = $("<option>").val(1).text(resp.data[i].DeptID + "-" + resp.data[i].DeptName);
                            $("#dept").append(option);
                        }
                    }
                });

            });
            //刷新
            $("#toolbtn_refresh").click(function () {
                location.reload();
            });
            $("#canbtn").click(function () {
                $('#empCollapse').collapse('toggle');
                $('#tablediv').toggle();
            });
            $("#savbtn").click(function () {
                //验证表单
                var errormsg = "";
                if ($("#empid").val() == "") {
                    errormsg += "用户编号不能为空!<br/>";
                }
                if ($("#empname").val() == "") {
                    errormsg += "用户名不能为空!<br/>";
                }
                if ($("#dept").val() == "") {
                    errormsg += "部门不能为空!<br/>";
                }
                if ($("#role").val() == "") {
                    errormsg += "角色不能为空!<br/>";
                }
                if ($("#psw").val() == "") {
                    errormsg += "密码不能为空!<br/>";
                }
                if (errormsg != "") {
                    $('#savbtn').popover({ "title": "提示", "content": errormsg, "placement": 'top', html: true });
                    $('#savbtn').popover('show');
                    setTimeout(function () {
                        $('#savbtn').popover('destroy');
                    }, 5000);
                    return;
                }
                var userinfo = {};
                userinfo.EmpID = $("#empid").val();
                userinfo.EmpName = $("#empname").val();
                userinfo.DeptID = $("#dept").find("option:selected").text();
                userinfo.RoleID = $("#role").find("option:selected").text();
                userinfo.Psw = $("#psw").val();
                //alert(userinfo.DeptID);
                //return;
                if ($("#action").val() == "U") {
                    $.ajax({
                        "type": "POST",
                        "url": "/handlers/sys.ashx",
                        "dataType": "json",
                        "data": { Action: 'UpdateUser', userinfo: JSON.stringify(userinfo) }, // 以json格式传递
                        "success": function (resp) {
                            if (resp.code == "0") {
                                $('#msgtext').html("修改成功！");
                                location.reload();
                            } else {
                                $('#msgtext').html(resp.msg);
                            }
                            $('#msgmodal').modal('show');
                        }
                    });
                } else {
                    $.ajax({
                        "type": "POST",
                        "url": "/handlers/sys.ashx",
                        "dataType": "json",
                        "data": { Action: 'AddUser', userinfo: JSON.stringify(userinfo) }, // 以json格式传递
                        "success": function (resp) {
                            if (resp.code == "0") {
                                $('#msgtext').html("添加成功！");
                                $("#psw").val("");
                                $("#empname").val("");
                                $("#empid").val("");
                            } else {
                                $('#msgtext').html(resp.msg);
                            }
                            $('#msgmodal').modal('show');
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>
    <%--    <form id="form1" runat="server">
        <div>
        </div>
    </form>--%>
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
            <div class="collapse" id="empCollapse">
                <div class="panel panel-primary">
                    <div class="panel-heading" id="panelheadtext">新增一条记录</div>
                    <div class="panel-body">
                        <input id="tempid" type="hidden" />
                        <input id="action" type="hidden" />
                        <div class="form-group">
                            <label for="empid" class="control-label">用户编号</label>
                            <input type="text" class="form-control" id="empid" placeholder="用户编号" />
                        </div>
                        <div class="form-group">
                            <label for="empname" class="control-label">用户名</label>
                            <input type="text" class="form-control" id="empname" placeholder="用户名" />
                        </div>
                        <div class="form-group">
                            <label for="psw" class="control-label">密码</label>
                            <input type="text" class="form-control" id="psw" placeholder="密码" />
                        </div>
                        <div class="form-group">
                            <label class="control-label">部门</label>
                            <select id="dept" data-width="100%" class="form-control"></select>
                        </div>
                        <div class="form-group">
                            <label class="control-label">角色</label>
                            <select id="role" data-width="100%" class="form-control">
                            </select>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <button id="savbtn" type="button" data-toggle="popover" class="btn btn-primary">&nbsp;&nbsp;&nbsp;保&nbsp;存&nbsp;&nbsp;&nbsp;</button>
                        <label id="msg"></label>
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
    <%--消息提示--%>
    <div id="msgmodal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">系统消息</h4>
                </div>
                <div class="modal-body">
                    <p id="msgtext"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">确定</button>
                    <%--<button type="button" class="btn btn-primary">Save changes</button>--%>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
    <%--消息提示--%>
    <div id="checkmodal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">系统消息</h4>
                </div>
                <div class="modal-body">
                    <input id="tempuserid" type="hidden" />
                    <p>确定执行操作？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="commit" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
</body>
</html>
