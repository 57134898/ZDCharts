<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="ZDCharts.ErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>出错了</div>
            <div><a href="Index.html">回首页</a></div>
            <div id="codediv" runat="server"></div>
            <div id="msgdiv" runat="server"></div>
        </div>
    </form>
</body>
</html>
