<%@page import="swallow.framework.entitydescript.EntityDescript"%>
<%@page import="org.springframework.util.StringUtils"%>
<%@page import="swallow.framework.entitydescript.EntityProperty"%>
<%@page import="com.swallow3.codetool.RequestData"%>
<%@ page language="java"  pageEncoding="utf-8"%>
<%
//  系统表格定义的代码模板
	EntityDescript data=(EntityDescript)request.getAttribute("data");
%>

import { getTableAction } from '@/libs/tablehelper'

let imgdel = require('@/assets/icon_del.png')
let imgopen = require('@/assets/icon_open.png')
let imgmodi = require('@/assets/icon_modi.png')

// 数据表格的列定义
export default function getActions (action:(index:number, actionName:string)=>void) {
  return [
    {
      type: 'selection',
      width: 60,
      align: 'center'
    }
<%
	for(EntityProperty prop:data.getProps()){
%>
    ,
    {
      title: '<%=prop.getCnname()%>',
      key: '<%=prop.getName() %>'
    }
<%
	}
%>
    ,

    {
      title: '操作',
      key: 'action',
      width: 180,
      align: 'center',
      render: (h:any, params:any) => getTableAction(h, params, [
        {
          name: 'del',
          image: imgdel
        },
        {
          name: 'modi',
          image: imgmodi
        },
        {
          name: 'view',
          image: imgopen
        }
      ], action)
    }

  ]
}
