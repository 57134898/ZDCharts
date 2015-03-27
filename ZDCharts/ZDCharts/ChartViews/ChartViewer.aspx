<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChartViewer.aspx.cs" Inherits="ZDCharts.ChartViews.ChartViewer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>图表浏览</title>
    <script src="../Scripts/jquery-2.1.3.min.js"></script>

    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../Content/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap.min.js"></script>

    <script src="../dist/echarts.js"></script>
</head>
<body>
    <script type="text/javascript">
   
    </script>
    <!-- Single button -->
    <div class="btn-group">
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
            选择 <span class="caret"></span>
        </button>
        <ul id="dropdownmenu" class="dropdown-menu" role="menu">
            <li><a href="#">Action</a></li>
            <li><a href="#">Another action</a></li>
            <li><a href="#">Something else here</a></li>

        </ul>
    </div>
</body>
</html>

