<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>用户管理</title>
    <%@include file="/common/tag.jspf" %>
    <%@include file="/common/common_css_js.jspf" %>
    <%--引入自定义通用工具类--%>
    <script src="${baseUrl}/js/knockout_common.js"></script>
</head>
<script type="text/javascript">
    var isChecked = false;//用于选择
    var model;
    //节点数据
    var originValue = ko.observable({
        //  id: 0,
        /*姓名*/
        jobSeekerName: '',
        /*性别*/
        jobSeekerSex: "",
        /*电话*/
        jobSeekerPhone: '',
        /*邮箱*/
        jobSeekerEmail: "",
        /*微信*/
        jobSeekerWeixin: "",
        /*毕业院校*/
        graduateSchool: "",
        /*所学专业*/
        majorSubjects: "",
        /*毕业时间*/
        graduateDate: "",
        isValid: "",
        serverCreateDate: "",
        serverUpdateDate: "",


    });
    var params = {
        pageSize: 2,//显示的页面大小
        currentPage: 0,//当前页
        //初始化节点数据
        EntityValue: ko.observable(new originValue()),
        //用于清空数据
        initValue: ko.observable(new originValue()),
        whereCondition: ko.observable(""),
        // 询的数据
        entityQueryUrl: function () {
            return "${baseUrl}/jobSeekerInfo/queryJobSeekerInfoListByCondition.action";
        },
        //新增实体url
        entityAddUrl: function () {
            // return "${baseUrl}/jobSeekerInfo/addSysUser.action";
        },
        //更改实体url
        entityUpdateUrl: function () {
            // return "${baseUrl}/jobSeekerInfo/updateSysUser.action";
        },
        //删除实体url
        entityDeleteUrl: function () {
            return "${baseUrl}/jobSeekerInfo/deleteJobSeekerInfoListByIds.action";
        },
        //总共记录查询
        totalCountQueryUrl: function () {
            //return "${baseUrl}/jobSeekerInfo/totalCount.action";

        },
        //返回选中框的标题
        checkedboxName: function () {
            return "itemCheck";
        }
    };
    $(function () {

        var model = new globalViewModel(params);

        //查询数据
        model.init();

        //激活绑定数据
        ko.applyBindings(model);
//        model.getPage = ko.observable(1);

        model.getWhereConditionAndQuery = function () {
            /*拼接查询条件*/
            var tmpWhereCondtion = "jobCode=" + $("#jobCode").val() + "&jobSeekerPhone=" + $("#jobSeekerPhone").val();
            model.whereCondition = model.js2ko(tmpWhereCondtion);
            model.dataQuery();

        }

    })


</script>


<body class="nav-md">

<div class="container body">


    <div class="main_container">
        <%--导航--%>
        <%-- <%@include file="navbar.jspf" %>
 --%>
        <!-- 主页内容-->
        <div class="right_col" role="main" style="min-height: 1000px;">
            <div class="page-title">
                <div class="title_left">
                    <h3>
                        求职者用户管理12345
                    </h3>
                </div>

                <div class="title_right">
                    <div class="col-md-5 col-sm-5 col-xs-12 form-group pull-right top_search">
                        <%--  <div class="input-group">
                              <input type="text" placeholder="职位编号" class="form-control">
                              <input type="text" placeholder="求职者电话" class="form-control">
                              <span class="input-group-btn">
                              <button type="button" class="btn btn-default"></button>
                          </span>
                          </div>--%>
                        <div class="form-group">
                            <label class="control-label col-md-3 col-sm-3 col-xs-12" for="first-name">First Name <span
                                    class="required">*</span>
                            </label>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                                <input type="text" id="first-name" required="required"
                                       class="form-control col-md-7 col-xs-12">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--弹窗--%>
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title " id="myModalLabel">求职者详情</h4>
                        </div>
                        <%--   &lt;%&ndash;主题内容&ndash;%&gt;--%>
                        <div class="modal-body">
                            <form class="form-horizontal form-label-left" data-parsley-validate="" id="demo-form2"
                                  data-bind="with: EntityValue">
                                <%--     <div class="form-group">
                                         <label for="nameid" class="control-label col-md-3 col-sm-3 col-xs-12">id
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="text" class="form-control col-md-7 col-xs-12" required="required"
                                                    data-bind='value:id'
                                                    id="nameid">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="name" class="control-label col-md-3 col-sm-3 col-xs-12">姓名
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="text" class="form-control col-md-7 col-xs-12" required="required"
                                                    data-bind='value:username'
                                                    id="name">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="usercode" class="control-label col-md-3 col-sm-3 col-xs-12">编号
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="text" class="form-control col-md-7 col-xs-12" required="required"
                                                    data-bind='value:usercode' id="usercode">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="email" class="control-label col-md-3 col-sm-3 col-xs-12">邮箱
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="email" class="form-control col-md-7 col-xs-12" required="required"
                                                    data-bind='value:email' id="email">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="salt" class="control-label col-md-3 col-sm-3 col-xs-12">盐
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="text" class="form-control col-md-7 col-xs-12" required="required"
                                                    data-bind='value:salt' id="salt">
                                         </div>
                                     </div>
                                     <div class="form-group">
                                         <label for="password" class="control-label col-md-3 col-sm-3 col-xs-12">密码
                                             <span class="required">*</span>
                                         </label>

                                         <div class="col-md-6 col-sm-6 col-xs-12">
                                             <input type="password" class="form-control col-md-7 col-xs-12"
                                                    required="required"
                                                    data-bind='value:password' id="password">
                                         </div>
                                     </div>--%>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                            <a type="button" class="btn btn-primary" data-bind="click:$root.saveOrUpdate">保存</a>
                        </div>
                    </div>
                </div>
            </div>

            <%--表格内容显示--%>
            <div class="x_panel">
                <%--  <div class="form-group">
                      <label class="control-label col-md-3 col-sm-3 col-xs-12" for="jobCode"><span class="required">*</span>
                      </label>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                          <input type="text" id="jobCode" required="required" class="form-control col-md-7 col-xs-12">
                      </div>
                  </div>--%>

                <div class="x_title">


                    <form class="form-horizontal form-label-left" style="margin-top: 1%">
                        <div class="form-group" style="float: right;width:80%">
                            <label class="control-label col-md-2 col-sm-3 col-xs-6" for="jobCode"><span
                                    class="required">职位编号</span>
                            </label>
                            <div class="col-md-2 col-sm-3 col-xs-6">
                                <input type="text" id="jobCode" required="required"
                                       class="form-control col-md-7 col-xs-12">
                            </div>

                            <label class="control-label col-md-2 col-sm-3 col-xs-6" for="jobSeekerPhone"><span
                                    class="required">求职者电话</span>
                            </label>
                            <div class="col-md-2 col-sm-3 col-xs-6">
                                <input type="text" id="jobSeekerPhone" required="required"
                                       class="form-control col-md-7 col-xs-12">
                            </div>
                            <div class="col-md-2 col-sm-3 col-xs-6">
                                <button type="button" class="btn btn-warning"
                                        data-bind="click:$root.getWhereConditionAndQuery">查询
                                </button>
                            </div>
                        </div>
                    </form>
                    <a class="btn btn-danger " data-bind="click:$root.remove"><i class="glyphicon glyphicon-trash"
                                                                                 style="font-size:15px"></i><font
                            style="font-size: 15px">批量删除</font></a>
                    <%--<a class="btn btn-primary " data-bind="click:$root.add"><i
                            class="glyphicon glyphicon-plus"
                            style="font-size:15px"></i><font
                            style="font-size: 15px">添加用户</font></a>--%>


                    <%-- <span style="float: right;font-size: 16px;color: black">共<u data-bind="text:$root.totalCount"></u>记录</span>--%>
                </div>
                <div class="x_content">

                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th style="width: 15px" id="checkItemId" name="itemCheck"
                                data-bind="click:$root.selectAll"><input type="checkbox">
                            </th>
                            <th>求职者姓名</th>
                            <th>求职者邮箱</th>
                            <th>性别</th>
                            <th>电话</th>
                            <th>微信</th>
                            <th>毕业院校</th>
                            <th>所学专业</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <%--绑定需操作数据--%>
                        <tbody data-bind="foreach:EntityValues">
                        <tr>
                            <th <%--style="width: 15px"--%>><input type="checkbox" name="itemCheck"
                                                                   data-bind="value:id,attr:{id:id}"></th>
                            <td data-bind="text:jobSeekerName"></td>
                            <td data-bind="text:jobSeekerEmail"></td>
                            <td data-bind="text:jobSeekerSex"></td>
                            <td data-bind="text:jobSeekerPhone"></td>
                            <td data-bind="text:jobSeekerWeixin"></td>
                            <td data-bind="text:graduateSchool"></td>
                            <td data-bind="text:majorSubjects"></td>
                            <td style="width:45px"><a href="javascript:" data-bind="click:$root.edit"
                            > <i class="glyphicon glyphicon-edit" style="font-size: large"></i></a></td>
                        </tr>
                        </tbody>
                    </table>

                </div>
                <div>
                    当前第<u data-bind="text:$root.currentPage"></u>页, 共 <u data-bind="text:$root.totalPage"></u> 页
                    <button class="btn btn-default " type="button" style="float:right" data-bind="click:$root.nextPage">
                        下一页
                    </button>
                    <button class="btn btn-default " type="button" style="float:right" data-bind="click:$root.prePage">
                        上一页
                    </button>

                </div>
            </div>

            <footer>
                <div class="copyright-info">
                    <p class="pull-right">Gentelella - Bootstrap Admin Template by <a href="https://colorlib.com">Colorlib</a>
                    </p>
                </div>
                <div class="clearfix"></div>
            </footer>
            <!-- /footer content -->
        </div>
        <!-- /page content -->

    </div>

</div>

<div id="custom_notifications" class="custom-notifications dsp_none">
    <ul class="list-unstyled notifications clearfix" data-tabbed_notifications="notif-group">
    </ul>
    <div class="clearfix"></div>
    <div id="notif-group" class="tabbed_notifications"></div>
</div>


</body>

</html>
