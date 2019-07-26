<%@page import="swallow.framework.entitydescript.EntityDescript"%>
<%@page import="org.springframework.util.StringUtils"%>
<%@page import="swallow.framework.entitydescript.EntityProperty"%>
<%@page import="com.swallow3.codetool.RequestData"%>
<%@ page language="java"  pageEncoding="utf-8"%>
<%
//  系统control的代码模板
	EntityDescript data=(EntityDescript)request.getAttribute("data");
	
%>

<template>
    <div class="wrapper">
    <Card :bordered="false">
      <Form  :label-width="50" inline>
        <FormItem label="用户名">
          <Input  placeholder="用户名" type="text" v-model="queryData.name"></Input>
        </FormItem>

        <FormItem >
          <Button shape="circle" type="primary" @click="freshFromServer">查询</Button>
          <Button style="margin-left:10px;" shape="circle" type="primary" ghost @click="onNewItem">新增</Button>
          <Button style="margin-left:10px;" shape="circle" type="primary" ghost @click="onDelTableItems">删除</Button>
        </FormItem>
      </Form>
      <Table ref="table" :columns="tableCols" :data="tabledata.items">
        <template slot="action">
          <img class="clear_icon" src="@/assets/iocn_shanchue.png" />
        </template>
      </Table>
    </Card>
    <div class="paging_con">
      <Page ref="tablePager" :total="tabledata.total"  show-total  show-elevator show-sizer />
    </div>
    <${modalname} ref="dialog"></${modalname}>
  </div>
</template>
<script lang="ts">
import { Prop, Vue, Component, Watch } from 'vue-property-decorator'
import getTableCols from './${tabdefines}'
import service, { ${name} } from '@/api/${uname}'
import request, { PagerData, PagerQueryData } from '../../libs/request'
import { PagerTableView, PagerTableViewMix, onDefaultTableAction, TableActionViewMix, TableActionView, TableActionDefine } from '@/libs/tablehelper'
import ${name}Modal from './${modalname}.vue'
import { ModalViewMix } from '../../libs/modalhelper'

@Component({ name: '${name}View', components: { ${name}Modal }, mixins: [ PagerTableViewMix, TableActionViewMix ] })
export default class extends Vue implements PagerTableView, TableActionView {
  queryData:PagerQueryData={
    page: 1,
    pageSize: 10,
    sorts: [],
    name: undefined
  }

  // 表格数据
  tabledata?:PagerData<any>={
    total: 0,
    items: []
  }

  // 表格操作定义
  tableActions:Array<TableActionDefine> = []

  // 表格列定义
  tableCols = getTableCols(((this as any) as TableActionViewMix).onDefaultTableAction)

  /**
 * 返回当前分页对象 这个方法需要mouted之后才可以使用
 */
  getPager () {
    return this.$refs.tablePager
  }

  // 从服务器取提数据
  fetchDataFromServer (curPage:number|undefined, pageSize:number|undefined) {
    if (curPage) {
      this.queryData.page = curPage
    }
    if (pageSize) {
      this.queryData.pageSize = pageSize
    }

    let loading = this.$Loading
    loading.start()
    service
      .fecthList(this.queryData)
      .then((pagers) => {
        this.tabledata = pagers.data
      })
      .catch((err) => {
        this.$Message.error('服务器返回错误:' + err.message)
      })
      .finally(() => {
        loading.finish()
      })
  }

  created () {
    this.freshFromServer()
  }

  // 将刷新函数挂入
  mounted () {
    let dialog = this.$refs.dialog as ModalViewMix
    dialog.setFreshTable(this.freshFromServer)
  }

  // 返回当前表格对象
  getTable ():any {
    return this.$refs.table
  }

  /**
     * 删除数据
     * @param ids 要删除数据的id值
     */
  onDelItems (ids:Array<number>):void{
    let loading = this.$Loading
    loading.start()
    service.deleteItemByIds(ids).then((ResponseData) => {
      this.fetchDataFromServer(undefined, undefined)
    }).catch((err) => {
      this.$Message.error('服务器返回错误:' + err.message)
    }).finally(() => {
      loading.finish()
    })
  }

  /**
     * 修改记录
     * @param id 记录ID值
     */
  onModiItem (dataItem:any):void{
    let dialog = this.$refs.dialog as ModalViewMix
    dialog.openForModi(dataItem)
  }

  /**
     * 查看记录
     * @param id 记录ID值
     */
  onViewItem (dataItem:any):void{
    let dialog = this.$refs.dialog as ModalViewMix
    dialog.openForView(dataItem)
  }

  /**
 * 创建一个新的对象
 */
  onNewItem ():void{
    let dialog = this.$refs.dialog as ModalViewMix
    dialog.openForNew()
  }
  //  刷新当前页
  freshFromServer ():void {
    this.fetchDataFromServer(undefined, undefined)
  }
}
</script>
<style lang="less" scoped>
@import '~@/global.less';

  .paging_con{
    margin-top:15px;
  }
  .modalRule_title{
    display: flex;
    align-items: center;
    font-size:18px;
    font-weight:bold;
    color: @sys-darkGray-cloror;

    img{
      width:40px;
      height: 36px;
      margin-right:10px;
    }
  }
  .form_con{
    margin-top:20px;

    .form_title{
      width:60px;
      text-align: right;
      font-size: 14px;
      color: #020C17;
      margin-bottom:15px;
    }
  }
</style>
