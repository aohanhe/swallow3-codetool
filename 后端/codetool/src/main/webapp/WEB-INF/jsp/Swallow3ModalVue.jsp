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
  <Modal v-model="isShow" :closable="false" class="modal_con" width="500" :mask-closable="false">
      <div class="modalRule_title">
        <img src="@/assets/yonghu.png" />
        <p>{{titlepre}}用户</p>
      </div>
      <Form :model="dataItem" :label-width="70" :rules="curRules" :key="key" class="form_con" ref="dataform">
        <FormItem label="用户名称" prop="name">
          <Input v-model="dataItem.name" placeholder="请输入名称" :clearable="!readOnly" style="width: 200px" :readonly="readOnly"/>
        </FormItem>
        
      </Form>
      <div class="btn_con">
        <Button shape="circle" type="primary" v-if="!addNew&&!readOnly" @click="saveData">保存</Button>
        <Button shape="circle" type="primary" v-if="addNew&&!readOnly" @click="inserData">新增</Button>
        <Button shape="circle" type="primary" ghost @click="isShow = false">{{readOnly?'关闭':'取消'}}</Button>
      </div>
    </Modal>
</template>
<script lang="ts">
import { Prop, Vue, Component, Watch } from 'vue-property-decorator'
import service, { ${name} } from '@/api/${uname}'
import { ModalViewMix, ModalView } from '@/libs/modalhelper'
import { Form } from 'iview'

@Component({ name: '${name}Modal', components: {}, mixins: [ModalViewMix] })
export default class ${name}Modal extends Vue implements ModalView {
    // 数据项
    private dataItem:${name}={}

    // 表单验证规则
    rules={
      name: [{ required: true, message: '名称不允许为空', trigger: 'blur' }]
    }

    // 设置数据
    setDataItem (dataItem:any):void{
      this.dataItem = dataItem
    }

    // 返回当前form对象
    getForm ():Form {
      return this.$refs.dataform as Form
    }

    // 保存数据
    onSaveData (suc:()=>void):void{
      let loading = this.$Loading
      loading.start()
      service.updateItem(this.dataItem).then((response) => {
        this.dataItem = response.data
        this.$Message.success('保存成功')
        if (suc) {
          suc()
        }
      }).catch((err) => {
        this.$Message.error('保存数据出错:' + err.message)
      }).finally(() => {
        loading.finish()
      })
    }

    // 插入数据
    onNewData (suc:()=>void):void{
      let loading = this.$Loading
      loading.start()
      service.saveNewItem(this.dataItem).then((response) => {
        this.dataItem = response.data
        this.$Message.success('保存成功')
        if (suc) {
          suc()
        }
      }).catch((err) => {
        this.$Message.error('保存数据出错:' + err.message)
      }).finally(() => {
        loading.finish()
      })
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
      width:31px;
      height: 35px;
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
    .addBtn_icon{
      margin-left:20px;
    }
    .addAreaList_con{
      background: #EEEEEE;
      padding:15px;
      border-radius: 10px;

      .addArea_list{
        display: flex;
        align-items: center;

        .addArea_text{
          flex:1;
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding:10px;
          border-bottom:#ccc solid 1px;
          margin-left:10px;

          .clear_icon{
            margin: 0 10px;
          }
        }
        &:last-child{

          .addArea_text{
            border-bottom:0;
          }
        }
      }
    }
  }
  .name_con{
    display: flex;
    justify-content: flex-start;
    align-items: center;

    .ivu-avatar{
      margin-right:10px;
    }
  }
</style>
