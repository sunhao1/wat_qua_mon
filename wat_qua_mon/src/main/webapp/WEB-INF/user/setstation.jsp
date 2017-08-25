<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    pageContext.setAttribute("basepath", request.getContextPath());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="${basepath}/main/css.jsp"></jsp:include>
    <title>检测站点列表</title>

    <style type="text/css">
        #pagination {
            margin: 0px 0px;
        }

        .pagination>li>a {
            background: #57697e;
            border: #c1cad5 solid 1px;
            color: #fff
        }

        .pagination>.active>a {
            border: #c1cad5 solid 1px;
            background: #e4e9f0;
            color: #57697e
        }

        #tbody td{text-align: center}

    </style>

    <jsp:include page="${basepath}/main/js.jsp"></jsp:include>

    <script type="text/javascript">
        jQuery(document).ready(function() {
            var selectType=0;//表示未点击查询按钮
            loadDataGird(selectType);
        });

        var createTable = function(index, item,pageNow) {

            var str = "";
            if(index%2==0){
                str =str+"<tr style='background:RGB(211,223,238)'>" + "<td>";
            }else{
                str =str+"<tr>" + "<td>";
            }
            str=str
                +"<input type='checkbox' name='checkboxs' id='"+item.id+"' value='"+item.name+"' onclick='itemscheck()'>"
                +"</td>"

                +"<td>"
                + (index + 1)
                + "</td>"

                + "<td>"
                + (item.name == null ? "" : item.name)
                + "</td>"
                + "<td>"
                + (item.number == null ? "" : item.number)
                + "</td>"
                + "<td>"
                + (item.address == null ? "" : item.address)
                + "</td>"
                + "<td>"
                + (item.type == null ? "" : item.type)
                + "</td>"
                + "<td>"
                + (item.coordinate == null ? "" : item.coordinate)
                + "</td>"
                + "<td>"
                + (item.unitId == null ? "" : item.unitId)
                + "</td>"

                + "</tr>	";
//            }else{
            str=str+ "</tr>	";
//            }

            $("#tbody").append(str);
        }

        var loadDataGird = function(selectType) {
            var url="";
            if(selectType==1){
//              初始化checkbox
                document.getElementById("ckAll").checked=0;
                var power=$("#power").val();
                $("#power1").val(power);//存储站名

                var power2=$("#power2").val();
                $("#power3").val(power2);//存储id

//                表示点击查询按钮,初始化当前页为1
                url="${basepath }/station/getlist?pageNow=1";
            }else{
                url="${basepath }/station/getlist?pageNow="+${pageHelp.pageBean.pageNow};
            }

            var name = $("#name").val();
            $.ajax({
                url : url,
                type : "post",
                data : {name:name},
                dataType : "json",
                success : function(data) {

                    $("#tbody").html("");
                    $('#pagination_div').html("");

                    if (data == null || data.total == 0) {
                        return;
                    }
                    $.each(data.list, function(index, item) { //遍历返回的json
                        createTable(index, item,data.pageNow);
                    });

                    //分页插件
                    $('#pagination_div').html(
                        "<ul id='pagination' class='pagination-sm' style='float:right'></ul>");
                    $('#pagination').twbsPagination({
                        startPage : data.pageNow,
                        totalPages : data.pageCount,
                        visiblePages : 5,
                        first : '首页',
                        prev : '上一页',
                        next : '下一页',
                        last : '末页',
                        onPageClick : function(event, page) {
//                            初始化checkbox
                            document.getElementById("ckAll").checked=0;
                            var power=$("#power").val();
                            $("#power1").val(power);//存储站名

                            var power2=$("#power2").val();
                            $("#power3").val(power2);//存储id

                            var name = $("#name").val();
                            $.ajax({
                                url : "${basepath }/station/getlist",
                                type : "post",
                                data : {pageNow:page,name:name},
                                dataType : "json",
                                success : function(data) {
                                    $("#tbody").html("");

                                    if (data == null|| data.total == 0) {
                                        return;
                                    }
                                    $.each(data.list,function(index,item) {
                                        createTable(index,item,data.pageNow);
                                    });
                                }
                            });
                        }
                    });
                    //分页插件end
                }
            });
        }

    </script>

    <script>
//        全选反选
        var checklist = document.getElementsByName ("checkboxs");
        var strvalue;
        var id;
        function selectAll() {
            var allstate=document.getElementById("ckAll").checked;
            strvalue="";
            id="";
            if(power1!=null){
                strvalue=$("#power1").val();
            }
            if(power3!=null){
                id=$("#power3").val();
            }

            if(allstate==true){
                    for(var i=0;i<checklist.length;i++)
                    {
                        checklist[i].checked = 1;
                        strvalue+=checklist[i].value+",";
                        id+=checklist[i].id+",";
                    }
                $("#power").val(strvalue);
                $("#power2").val(id);
                }else {
                for (var j = 0; j < checklist.length; j++) {
                    checklist[j].checked = 0;
                }
                $("#power").val($("#power1").val());
                $("#power2").val($("#power3").val());
            }

        }

        function itemscheck() {
            var falg = true;
            strvalue="";
            id="";

            if(power1!=null){
                strvalue=$("#power1").val();
            }
            if(power3!=null){
                id=$("#power3").val();
            }
            for (var j = 0; j < checklist.length; j++) {
                if (checklist[j].checked == 0){
                    falg = false;
                }else{
                    strvalue+=checklist[j].value+",";
                    id+=checklist[j].id+",";
                }
            }

            $("#power").val(strvalue);
            $("#power2").val(id);
            if(falg){
                document.getElementById("ckAll").checked=1;
            }else{
                document.getElementById("ckAll").checked=0;
            }

        }

    </script>

</head>
<body>

<div class='row' style="margin: 0px">
    <div class='col-md-12'>
        <form class="form-inline" role="form"
              style='float: right;margin-bottom:10px;margin-top: 5px;margin-left: 5px '>
            <div class="form-group">
                <input type="text" class="form-control" id="name" value="${pageHelp.selectStr}" placeholder="站名">
            </div>
            <button type="button" onclick="loadDataGird(1)" class="btn btn-info"  style='background: #4F81BD;border: 1px solid #4F81BD' >查询</button>
        </form>
    </div>
</div>

<div class='row' style="margin: 0px">
    <div class='col-md-12'>
        <table class="table table-bordered">
            <thead style='background:#A8BC7B;color:#fff'>
            <tr>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'><input type='checkbox' onclick="selectAll()" id="ckAll"></th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>序号</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>名称</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>编号</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>位置</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>类型</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>坐标</th>
                <th class="text-center"  style='background:RGB(79,129,189);color:#fff'>单位</th>
            </tr>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>

        <div class="form-row">
            <div class="form-input col-md-5">
                <input id="power" type="text">
                <input id="power1" type="hidden">
                <input id="power2" type="hidden">
                <input id="power3" type="hidden">
            </div>
        </div>
        <div class="dataTables_info" id="dynamic-table_info"
             style="float: left;">
            <a class="btn btn-info" style='background: #4F81BD;border: 1px solid #4F81BD'
               href="${basepath}/station/toadd">
                <span class="button-content">确认分配</span> </a>
        </div>
        <div id="pagination_div" style='float: right;padding-right: 0px'>

        </div>
    </div>
</div>


</body>


</html>